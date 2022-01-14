#!/bin/bash

export CORE_PEER_LOCALMSPID=Org2MSP \
export CORE_PEER_ADDRESS=peer0.org2.example.com:7051 \
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt \
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key \
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp

peer lifecycle chaincode approveformyorg -o orderer.example.com:7050 --tls --cafile $ORDERER_TLS_CA --channelID allarewelcome --name sacc --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1

peer lifecycle chaincode checkcommitreadiness --channelID allarewelcome --name sacc --version 1.0 --sequence 1 --output json

peer lifecycle chaincode commit -o orderer.example.com:7050 --tls --cafile  $ORDERER_TLS_CA --channelID allarewelcome --name sacc --version 1.0 --sequence 1 --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt

peer chaincode invoke -o orderer.example.com:7050 --tls --cafile $ORDERER_TLS_CA -C allarewelcome -n sacc --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles  $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt -c '{"function":"set","args":["key1", "value1"]}' --waitForEvent  

peer chaincode query -C allarewelcome -n sacc --peerAddresses $CORE_PEER_ADDRESS  --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"function":"get","args":["key1"]}'

discover --configFile discovery-conf.yaml --peerTLSCA $CORE_PEER_TLS_ROOTCERT_FILE --userKey /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/keystore/priv_sk --userCert /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/signcerts/User1@org1.example.com-cert.pem --MSP Org1MSP saveConfig

discover --configFile discovery-conf.yaml ​endorsers ​--channel allarewelcome --server peer0.org1.example.com:7051 --chaincode sacc

discover --configFile discovery-conf.yaml config --channel allarewelcome --server peer0.org1.example.com:7051

discover --configFile discovery-conf.yaml peers --channel allarewelcome --server peer0.org1.example.com:7051

docker exec -it peer1.org1.example.com /bin/sh

docker exec -it -e MY_VAR=MY_VALUE peer1.org1.example.com /bin.sh

docker logs -f peer0.org1.example.com

fabric-ca-server start -b caServerAdmin:AdminsRock --loglevel debug

docker ps -a --format "table {{.ID}}\t{{.Names}}"












































