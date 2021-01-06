
export FABRIC_CFG_PATH=${PWD}/configtx
echo $FABRIC_CFG_PATH
#Create Orderers oraganization and it's Peers
# System channel
SYS_CHANNEL="sys-channel"
# channel name defaults to "mychannel"
CHANNEL_NAME="mychannel"

#removing conatiners And mounted volumes
rm -r ./organizations/
rm -r ./system-genesis-block/
rm -r ./channel-artifacts/
./bin/cryptogen generate --config=uit.yaml --output="organizations"
./bin/cryptogen generate --config=iba.yaml --output="organizations"
./bin/cryptogen generate --config=crypto-config-orderer.yaml --output="organizations"
./bin/configtxgen -profile TwoOrgsOrdererGenesis -channelID $SYS_CHANNEL --outputBlock ./system-genesis-block/genesis.block
./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME


