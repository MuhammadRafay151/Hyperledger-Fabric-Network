export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/uit.com/peers/peer0.uit.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/ned.com/peers/peer0.ned.com/tls/ca.crt
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  echo "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="uitMSP"
   
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/uit.com/users/Admin@uit.com/msp
    
    export CORE_PEER_ADDRESS=localhost:$2
   
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="NedMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/ned.com/users/Admin@ned.com/msp
    export CORE_PEER_ADDRESS=localhost:$2
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

