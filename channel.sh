CHANNEL_NAME="mychannel"
DELAY=3
MAX_RETRY=5
VERBOSE="false"

export PATH=${PWD}/bin
export FABRIC_CFG_PATH=${PWD}/configtx
#import globals
source scriptUtils.sh
. globals.sh
CHANNEL_NAME="mychannel"
Organizations=("NedMSP" "uitMSP")
createChannelTx() {

	set -x
	./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
	res=$?
	{ set +x; } 2>/dev/null
	if [ $res -ne 0 ]; then
		echo "Failed to generate channel configuration transaction..."
		exit 1
	fi

}
createAncorPeerTx() {
	echo "Generating anchor peer update transaction for ${1}"
	set -x
	configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/${1}anchors.tx -channelID $CHANNEL_NAME -asOrg ${1}
	res=$?
	{ set +x; } 2>/dev/null
	if [ $res -ne 0 ]; then
		echo "Failed to generate anchor peer update transaction for ${1}..."
		exit 1
	fi
	
}
createChannel() {
	setGlobals 1
	# Poll in case the raft leader is not set yet
	# local rc=1
	# local COUNTER=1
	# while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
	# 	sleep $DELAY
	# 	set -x
	# 	res=$?
	# 	{ set +x; } 2>/dev/null
	# 	let rc=$res
	# 	COUNTER=$(expr $COUNTER + 1)
	# done
	# cat log.txt
	# verifyResult $res "Channel creation failed"
	# successln "Channel '$CHANNEL_NAME' created"
	peer channel create -o localhost:7050 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer.example.com -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block --tls --cafile $ORDERER_CA >&log.txt

}

joinChannel() {
  
  setGlobals 1 7051
  peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block >&log.txt 
  setGlobals 1 7053
  peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block >&log.txt 
  setGlobals 1 7055
  peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block >&log.txt 
  setGlobals 2 9051
  peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block >&log.txt 
  setGlobals 2 9053
  peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block >&log.txt 
  setGlobals 2 9055
  peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block >&log.txt 
   
}
updateAnchorPeers(){
    setGlobals 1 7051
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    setGlobals 2 9051
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
}
verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
# createChannelTx
createAncorPeerTx "uitmsp"
createAncorPeerTx "ibamsp"
# export FABRIC_CFG_PATH=$PWD/config

#echo "Creating channel ${CHANNEL_NAME}"
# createChannel
# joinChannel
# updateAnchorPeers