#!/bin/bash

unset region
unset profile
unset clusterName

usage() {
  echo "Usage: CreateUserAndRoles [ -r | --region ]
                  [ -p | --profile ]
                  [ -c | --clusterName ]"
  exit 2
}

PARSED_ARGUMENTS=$(getopt -a -n CreateUserAndRoles -o r:p:c: --long region:,profile:,clusterName: -- "$@")
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
echo "region ${region}"
echo "profile ${profile}"
echo "clusterName ${clusterName}"
echo "Parameters remaining are: $@"
echo "************************************************************"


terraform init
terraform apply \
  -var "region=${region}" \
  -var "profile=${profile}" \
  -var "cluster_name=${clusterName}"
  -auto-approve
