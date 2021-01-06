IMAGETAG="latest"
# use this as the default docker-compose yaml definition
COMPOSE_FILE_BASE=docker-compose-test-net.yaml


export COMPOSE_PROJECT_NAME="orderer"
IMAGE_TAG=$IMAGETAG docker-compose -f $COMPOSE_FILE_BASE up -d
