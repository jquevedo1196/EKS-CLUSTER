#!/bin/bash

unset account
unset profile
unset clusterName
unset roleName

usage() {
  echo "Usage: ClusterLogging [ -a | --account ]
                  [ -p | --profile ]
                  [ -c | --clusterName ]
                  [ -r | --roleName ]"
  exit 2
}

PARSED_ARGUMENTS=$(getopt -a -n ClusterLogging -o a:p:r: --long account:,profile:,roleName:,clusterName:, -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

echo "PARSED_ARGUMENTS is $PARSED_ARGUMENTS"
eval set -- "$PARSED_ARGUMENTS"
while :; do
  case "$1" in
  -c | --account)
    account="$2"
    shift 2
    ;;
  -r | --profile)
    profile="$2"
    shift 2
    ;;
  -p | --roleName)
    roleName="$2"
    shift 2
    ;;
  -c | --clusterName)
    clusterName="$2"
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
echo "account ${account}"
echo "profile ${profile}"
echo "roleName ${roleName}"
echo "clusterName ${clusterName}"
echo "Parameters remaining are: $@"
echo "************************************************************"

curl -o permissions.json \
  https://raw.githubusercontent.com/aws-samples/amazon-eks-fluent-logging-examples/mainline/examples/fargate/cloudwatchlogs/permissions.json

aws iam create-policy \
  --policy-name "eks-fargate-logging-policy-${clusterName}" \
  --policy-document file://permissions.json --profile "${profile}"

echo "aws iam attach-role-policy --policy-arn arn:aws:iam::${account}:policy/eks-fargate-logging-policy-${clusterName} --role-name ${roleName} --profile ${profile}"
aws iam attach-role-policy \
  --policy-arn "arn:aws:iam::${account}:policy/eks-fargate-logging-policy-${clusterName}" \
  --role-name "${roleName}" --profile "${profile}"

export CLUSTER_NAME_FLUENTB=$clusterName
(envsubst <FluentBit.yaml.template) >FluentBit.yaml

kubectl apply -f FluentBit.yaml
