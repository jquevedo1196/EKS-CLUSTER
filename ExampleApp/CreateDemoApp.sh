#!/bin/bash

unset clusterName
unset region
unset profile

usage() {
  echo "Usage: CreateDemoApp [ -c | --clusterName ]
                  [ -r | --region ]
                  [ -p | --profile ]"
  exit 2
}

PARSED_ARGUMENTS=$(getopt -a -n CreateDemoApp -o c:r:p: --long clusterName:,region:,profile:, -- "$@")
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
  -r | --region)
    region="$2"
    shift 2
    ;;
  -p | --profile)
    profile="$2"
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
echo "region ${region}"
echo "profile ${profile}"
echo "Parameters remaining are: $@"
echo "************************************************************"

eksctl create fargateprofile \
  --cluster "${clusterName}" \
  --region "${region}" \
  --name fp-demo \
  --namespace demo --profile "${profile}"

kubectl apply -f .
