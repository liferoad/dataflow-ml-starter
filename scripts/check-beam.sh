#!/bin/bash

# Import environment variables from .env file.
source .env

# Check if the project ID and zone environment variables are set.
if [ -z "${PROJECT_ID}" ]; then
  echo "The PROJECT_ID environment variable is not set."
  exit 1
fi

if [ -z "${ZONE}" ]; then
  echo "The ZONE environment variable is not set."
  exit 1
fi

if [ -z "${VM_NAME}" ]; then
  echo "The VM_NAME environment variable is not set."
  exit 1
fi

if [ -z "${CUSTOM_CONTAINER_IMAGE}" ]; then
  echo "The CUSTOM_CONTAINER_IMAGE environment variable is not set."
  exit 1
fi

echo "Checking Python version on VM..."
gcloud compute ssh --strict-host-key-checking=no $VM_NAME --project $PROJECT_ID --zone=$ZONE --quiet --command \
"docker run --entrypoint /bin/bash --volume /var/lib/nvidia/lib64:/usr/local/nvidia/lib64 \
  --volume /var/lib/nvidia/bin:/usr/local/nvidia/bin \
  --privileged $CUSTOM_CONTAINER_IMAGE -c \
  \"python --version\""

echo "Checking venv exists on VM..."
gcloud compute ssh --strict-host-key-checking=no $VM_NAME --project $PROJECT_ID --zone=$ZONE --quiet --command \
"docker run --entrypoint /bin/bash --volume /var/lib/nvidia/lib64:/usr/local/nvidia/lib64 \
  --volume /var/lib/nvidia/bin:/usr/local/nvidia/bin \
  --privileged $CUSTOM_CONTAINER_IMAGE -c \
  'apt list --installed | grep python3-venv'"

echo "Checking Beam Version on VM..."
gcloud compute ssh --strict-host-key-checking=no $VM_NAME --project $PROJECT_ID --zone=$ZONE --quiet --command \
"docker run --entrypoint /bin/bash --volume /var/lib/nvidia/lib64:/usr/local/nvidia/lib64 \
  --volume /var/lib/nvidia/bin:/usr/local/nvidia/bin \
  --privileged $CUSTOM_CONTAINER_IMAGE -c \
  \"python -c 'import apache_beam as beam; print(beam.__version__)'\""