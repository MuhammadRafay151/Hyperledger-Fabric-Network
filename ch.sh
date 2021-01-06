
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="uitmsp"
export CORE_PEER_ADDRESS=localhost:7051
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/uit.com/peers/peer0.uit.com/tls/ca.crt
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/uit.com/users/Admin@uit.com/msp
export CHANNEL_NAME=mychannel
export FABRIC_CFG_PATH=$PWD/config
./bin/peer channel create -o orderer0.example.com -c $CHANNEL_NAME  -f ./channel-artifacts/mychannel.tx --tls --cafile $ORDERER_CA 

#create channel
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
CHANNEL_NAME=mychannel
peer channel create -o orderer0.example.com:6050 -c $CHANNEL_NAME  -f ./channel-artifacts/mychannel.tx --tls --cafile $ORDERER_CA 
#join peer 0
peer channel join -b mychannel.block
#all commands will execute using uit peer0 cli 
#just pass channel name and orderer ca path in case of channel creation and anchor peer update
#we don't need to set environemnt varible for uit peer0 beacues we have built cli conatiner of peer 0 so it is already configured
#setting environment varible for uit peer1
CORE_PEER_LOCALMSPID="uitmsp"
CORE_PEER_ADDRESS=peer1.uit.com:7053
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/uit.com/peers/peer1.uit.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/uit.com/users/Admin@uit.com/msp
peer channel join -b mychannel.block

#join channel iba we need to set environment variables we have iba mentioned in channel block so iba can join wihtout the need of ordering cert
CORE_PEER_LOCALMSPID="ibamsp"
CORE_PEER_ADDRESS=peer0.iba.com:9051
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/peers/peer0.iba.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/users/Admin@iba.com/msp
peer channel join -b mychannel.block

CORE_PEER_LOCALMSPID="ibamsp"
CORE_PEER_ADDRESS=peer1.iba.com:9053
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/peers/peer1.iba.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/users/Admin@iba.com/msp
peer channel join -b mychannel.block



#channel update for uit as we have cli for uit peer0 so we dont need to set environrmnt variable
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
CHANNEL_NAME=mychannel
peer channel update -o orderer0.example.com:6050 -c $CHANNEL_NAME -f ./channel-artifacts/uitmspanchors.tx --tls --cafile $ORDERER_CA

#channel update for iba we need to provide environment varible
CORE_PEER_LOCALMSPID="ibamsp"
CORE_PEER_ADDRESS=peer0.iba.com:9051
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/peers/peer0.iba.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/users/Admin@iba.com/msp
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
CHANNEL_NAME=mychannel
peer channel update -o orderer0.example.com:6050 -c $CHANNEL_NAME -f ./channel-artifacts/ibamspanchors.tx --tls --cafile $ORDERER_CA

#chaincode package
peer lifecycle chaincode package fabcar.tar.gz --path /opt/gopath/src/github.com/chaincode/fabcar/javascript --lang node --label fabcar_1

#chain code installation on peers
#for peer0 uit we donot want to overide variable if the terminal is new if we overiede before so we need to overide or exit and re-entger cli again
peer lifecycle chaincode install fabcar.tar.gz
#for peer1 uit override variable
CORE_PEER_LOCALMSPID="uitmsp"
CORE_PEER_ADDRESS=peer1.uit.com:7053
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/uit.com/peers/peer1.uit.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/uit.com/users/Admin@uit.com/msp
peer lifecycle chaincode install fabcar.tar.gz

#for peer0 iba override variable
CORE_PEER_LOCALMSPID="ibamsp"
CORE_PEER_ADDRESS=peer0.iba.com:9051
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/peers/peer0.iba.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/users/Admin@iba.com/msp
peer lifecycle chaincode install fabcar.tar.gz

CORE_PEER_LOCALMSPID="ibamsp"
CORE_PEER_ADDRESS=peer1.iba.com:9053
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/peers/peer1.iba.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/users/Admin@iba.com/msp
peer lifecycle chaincode install fabcar.tar.gz

#chain code approve
#so we need to pass orderer ca certificate for approval submit to orderer
#only one peer needs to approve chain code from each org so maximum org approval reuired to update chaincode on channel
#peer 0 uit as we have cli donot overirder if it is already overide in current cli session
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
CHANNEL_NAME=mychannel
peer lifecycle chaincode approveformyorg -o orderer0.example.com:6050  --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name fabcar --version 1 --sequence 1 --waitForEvent --package-id fabcar_1:8b6fa54ca73d57cad1be414229ff6f6a8652c6cdb4feca79581382c4bcdbf246

#peer 0 iba
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
CHANNEL_NAME=mychannel
CORE_PEER_LOCALMSPID="ibamsp"
CORE_PEER_ADDRESS=peer0.iba.com:9051
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/peers/peer0.iba.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/users/Admin@iba.com/msp
peer lifecycle chaincode approveformyorg -o orderer0.example.com:6050  --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name fabcar --version 1 --sequence 1 --waitForEvent --package-id fabcar_1:8b6fa54ca73d57cad1be414229ff6f6a8652c6cdb4feca79581382c4bcdbf246
#check commit readiness
peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name fabcar --version 1 --sequence 1

#commit chain code on peers
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
PEER0_UIT_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/uit.com/peers/peer0.uit.com/tls/ca.crt
PEER0_IBA_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/peers/peer0.iba.com/tls/ca.crt
CHANNEL_NAME=mychannel
CC_NAME=fabcar
peer lifecycle chaincode commit -o orderer0.example.com:6050 \
  --tls --cafile $ORDERER_CA \
  --channelID $CHANNEL_NAME --name ${CC_NAME} \
  --peerAddresses peer0.uit.com:7051 --tlsRootCertFiles $PEER0_UIT_CA \
  --peerAddresses peer0.iba.com:9051 --tlsRootCertFiles $PEER0_IBA_CA \
  --version 1 --sequence 1

#check query commited eith it is enabled on the peers or not
peer lifecycle chaincode querycommitted --channelID mychannel --name fabcar
#now test the chain code by invoking smart contract
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
PEER0_UIT_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/uit.com/peers/peer0.uit.com/tls/ca.crt
PEER0_IBA_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/iba.com/peers/peer0.iba.com/tls/ca.crt
CHANNEL_NAME=mychannel
CC_NAME=fabcar
  peer chaincode invoke -o orderer0.example.com:6050  \
  --tls true --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
  --peerAddresses peer0.uit.com:7051 --tlsRootCertFiles $PEER0_UIT_CA \
  --peerAddresses peer0.iba.com:9051 --tlsRootCertFiles $PEER0_IBA_CA \
  -c '{"function":"initLedger","Args":[]}'


#fetch channel latest block
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer channel fetch newest mychannel.block -c mychannel --orderer orderer0.example.com:6050 --tls --cafile $ORDERER_CA 