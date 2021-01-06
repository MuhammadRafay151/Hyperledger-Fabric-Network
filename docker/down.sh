COMPOSE_FILE_BASE=docker-compose-test-net.yaml
# docker-compose.yaml file if you are using couchdb
COMPOSE_FILE_COUCH=docker-compose-couch.yaml
# certificate authorities compose file
COMPOSE_FILE_CA=docker-compose-ca.yaml
export COMPOSE_PROJECT_NAME="first"
docker-compose -f $COMPOSE_FILE_BASE -f $COMPOSE_FILE_COUCH -f $COMPOSE_FILE_CA down --volumes --remove-orphans
rm -r ../system-genesis-block
rm -r ../organizations
rm -r ../channel-artifacts
