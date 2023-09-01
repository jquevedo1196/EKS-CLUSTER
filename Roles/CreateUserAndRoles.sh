#!/bin/bash

unset region
unset profile
unset groupName
unset userName
unset policyName
unset policyFile
unset clusterName
unset account
unset groupEKS

usage() {
  echo "Usage: CreateUserAndRoles [ -r | --region ]
                  [ -p | --profile ]
                  [ -g | --groupName ]
                  [ -u | --userName ]
                  [ -n | --policyName ]
                  [ -f | --policyFile ]
                  [ -c | --clusterName ]
                  [ -a | --account ]
                  [ -e | --groupEKS ]"
  exit 2
}

PARSED_ARGUMENTS=$(getopt -a -n CreateUserAndRoles -o r:p:g:u:n:f:c:a:e: --long region:,profile:,groupName:,userName:,policyName:,policyFile:,clusterName:,account:,groupEKS:, -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

echo "PARSED_ARGUMENTS is $PARSED_ARGUMENTS"
eval set -- "$PARSED_ARGUMENTS"
while :; do
  case "$1" in
  -r | --region)
    region="$2"
    shift 2
    ;;
  -p | --profile)
    profile="$2"
    shift 2
    ;;
  -g | --groupName)
    groupName="$2"
    shift 2
    ;;
  -u | --userName)
    userName="$2"
    shift 2
    ;;
  -n | --policyName)
    policyName="$2"
    shift 2
    ;;
  -f | --policyFile)
    policyFile="$2"
    shift 2
    ;;
  -c | --clusterName)
    clusterName="$2"
    shift 2
    ;;
  -a | --account)
    account="$2"
    shift 2
    ;;
  -v | --groupEKS)
    groupEKS="$2"
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
echo "region ${region}"
echo "profile ${profile}"
echo "groupName ${groupName}"
echo "userName ${userName}"
echo "policyName ${policyName}"
echo "policyFile ${policyFile}"
echo "clusterName ${clusterName}"
echo "account ${account}"
echo "groupEKS ${groupEKS}"
echo "Parameters remaining are: $@"
echo "************************************************************"

kubectl apply -f ./ManagerRole.yaml
terraform init
terraform apply \
  -var "region=${region}" \
  -var "profile=${profile}" \
  -var "group_name=${groupName}" \
  -var "user_name=${userName}" \
  -var "policy_name=${policyName}" \
  -var "policy_file=${policyFile}" \
  -auto-approve
echo "[manager]" >>credentials
echo "aws_access_key_id=$(terraform output -raw secret_key)" >>credentials
echo "aws_secret_access_key=$(terraform output -raw access_key)" >>credentials
eksctl create iamidentitymapping \
  --cluster "${clusterName}" \
  --region="${region}" \
  --arn arn:aws:iam::"${account}":user/"${userName}" \
  --group "${groupEKS}" \
  --no-duplicate-arns \
  --profile "${profile}"
