IMAGETAG="latest"
COMPOSE_FILE_BASE=docker-compose-test-net.yaml

export COMPOSE_PROJECT_NAME="orderer"
IMAGE_TAG=$IMAGETAG docker-compose -f $COMPOSE_FILE_BASE  down --volumes --remove-orphans

