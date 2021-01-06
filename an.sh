export FABRIC_CFG_PATH=${PWD}/configtx
CHANNEL_NAME="mychannel"
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/uitmspanchors.tx -channelID $CHANNEL_NAME -asOrg uitmsp
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/ibamspanchors.tx -channelID $CHANNEL_NAME -asOrg ibamsp