#!/bin/bash

unset clusterName
unset subnetPrivA
unset subnetPrivB
unset subnetPubA
unset subnetPubB
unset region
unset profile
unset account
unset vpc

usage() {
  echo "Usage: CreateAndConfigureCluster [ -c | --clusterName ]
                  [ -w | --subnetPrivA ]
                  [ -x | --subnetPrivB ]
                  [ -y | --subnetPubA ]
                  [ -z | --subnetPubB ]
                  [ -r | --region ]
                  [ -p | --profile ]
                  [ -a | --account ]
                  [ -v | --vpc ]"
  exit 2
}

PARSED_ARGUMENTS=$(getopt -a -n CreateAndConfigureCluster -o c:w:x:y:z:r:p:a:v: --long clusterName:,subnetPrivA:,subnetPrivB:,subnetPubA:,subnetPubB:,region:,profile:,account:,vpc:, -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

echo "PARSED_ARGUMENTS is $PARSED_ARGUMENTS"
eval set -- "$PARSED_ARGUMENTS"
while :; do
  case "$1" in
  -c | --clusterName)
    clusterName="$2"
    shift 2
    ;;
  -w | --subnetPrivA)
    subnetPrivA="$2"
    shift 2
    ;;
  -x | --subnetPrivB)
    subnetPrivB="$2"
    shift 2
    ;;
  -y | --subnetPubA)
    subnetPubA="$2"
    shift 2
    ;;
  -z | --subnetPubB)
    subnetPubB="$2"
    shift 2
    ;;
  -r | --region)
    region="$2"
    shift 2
    ;;
  -p | --profile)
    profile="$2"
    shift 2
    ;;
  -a | --account)
    account="$2"
    shift 2
    ;;
  -v | --vpc)
    vpc="$2"
    shift 2
    ;;
  # -- means the end of the arguments; drop this, and break out of the while loop
  --)
    shift
    break
    ;;
  # If invalid options were passed, then getopt should have reported an error,
  # which we checked as VALID_ARGUMENTS when getopt was called...
  *)
    echo "Unexpected option: $1 - this should not happen."
    usage
    ;;
  esac
done

echo "************************************************************"
echo "clusterName ${clusterName}"
echo "subnetPrivA ${subnetPrivA}"
echo "subnetPrivB ${subnetPrivB}"
echo "subnetPubA ${subnetPubA}"
echo "subnetPubB ${subnetPubB}"
echo "region ${region}"
echo "profile ${profile}"
echo "account ${account}"
echo "vpc ${vpc}"
echo "current directory $(pwd)"
echo "Parameters remaining are: $@"
echo "************************************************************"

echo "eksctl create cluster --name ${clusterName} --region ${region} --version=1.24 --fargate --vpc-private-subnets=${subnetPrivA},${subnetPrivB} --profile ${profile}"
eksctl create cluster --name "${clusterName}" --region "${region}" --version=1.24 --fargate --vpc-private-subnets="${subnetPrivA}","${subnetPrivB}" --profile "${profile}"

oidc_id=$(aws eks describe-cluster --name "${clusterName}" --query "cluster.identity.oidc.issuer" --output text --profile "${profile}" | cut -d '/' -f 5)

echo "aws iam list-open-id-connect-providers --profile ${profile} | grep $oidc_id"
aws iam list-open-id-connect-providers --profile "${profile}" | grep "$oidc_id"

eksctl utils associate-iam-oidc-provider --cluster "${clusterName}" --approve --profile "${profile}"

curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/install/iam_policy.json &&
  aws iam create-policy \
    --policy-name "AWSLoadBalancerControllerIAMPolicy-${clusterName}" \
    --policy-document file://iam_policy.json \
    --profile "${profile}"

eksctl create iamserviceaccount \
  --cluster="${clusterName}" \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name "AmazonEKSLoadBalancerControllerRole-${clusterName}" \
  --attach-policy-arn="arn:aws:iam::${account}:policy/AWSLoadBalancerControllerIAMPolicy-${clusterName}" \
  --approve --profile "${profile}"

helm repo add eks https://aws.github.io/eks-charts

helm repo update

kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName="${clusterName}" \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller

helm delete aws-load-balancer-controller -n kube-system

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --set clusterName="${clusterName}" \
  -n kube-system \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region="${region}" \
  --set vpcId="${vpc}" \
  --set image.repository=602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller
#602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller repo de la imagen para us-east-1

terraform init
terraform apply \
  -var "cluster_name=${clusterName}" \
  -var "subn_priv_1=${subnetPrivA}" \
  -var "subn_priv_2=${subnetPrivB}" \
  -var "subn_pub_1=${subnetPubA}" \
  -var "subn_pub_2=${subnetPubB}" \
  -var "profile=${profile}" \
  -var "region=${region}" \
  -auto-approve
