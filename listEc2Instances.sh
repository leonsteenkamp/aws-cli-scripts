#!/usr/bin/env bash
# Install jq for this to work --> sudo apt install jq
date
REGIONS=`aws ec2 describe-regions --query Regions[*].[RegionName] --output text`

count=`echo "$REGIONS" | wc -l`
echo "Counted $count regions"

set +m
for REGION in $REGIONS
do
  echo -e "Checking for instances in '$REGION'..";

  aws ec2 describe-instances --region $REGION | \
  jq ".Reservations[].Instances[] | {InstanceId: .InstanceId, type: .InstanceType, state: .State.Name, tags: .Tags, zone: .Placement.AvailabilityZone}" &


done
wait
set -m

