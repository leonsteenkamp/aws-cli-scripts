#!/usr/bin/env bash
# Install jq for this to work --> sudo apt install jq
date
REGIONS=`aws ec2 describe-regions --query Regions[*].[RegionName] --output text`

count=`echo "$REGIONS" | wc -l`
echo "Counted $count regions"

set +m
for REGION in $REGIONS
do
  echo -e "Checking for volumes in '$REGION'..";

  aws ec2 describe-volumes --region $REGION | \
  jq ".Volumes[] | {AvailabilityZone: .AvailabilityZone, InstanceID: .Attachments[].InstanceId, AttachmentState: .Attachments[].State, VolumeID: .Attachments[].VolumeId, Attached: .Attachments[].AttachTime, State: .State}" &


done
wait
set -m

