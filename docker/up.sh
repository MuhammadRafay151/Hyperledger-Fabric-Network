IMAGETAG="latest"
# use this as the default docker-compose yaml definition
COMPOSE_FILE_BASE=docker-compose-test-net.yaml
# docker-compose.yaml file if you are using couchdb
COMPOSE_FILE_COUCH=docker-compose-couch.yaml
# certificate authorities compose file
COMPOSE_FILE_CA=docker-compose-ca.yaml
COMPOSE_FILES="-f ${COMPOSE_FILE_BASE}"
COMPOSE_FILES="${COMPOSE_FILES} -f ${COMPOSE_FILE_COUCH} "
echo $COMPOSE_FILES
export COMPOSE_PROJECT_NAME="first"
IMAGE_TAG=$IMAGETAG docker-compose ${COMPOSE_FILES} up -d
