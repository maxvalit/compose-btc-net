set -e

# Default configuration values
RPCUSER=${RPCUSER:-bitcoin}
RPCPASSWORD=${RPCPASSWORD:-local321}
RPCPORT=${RPCPORT:-8332}
NETWORK=${NETWORK:-regtest}
MINE=${MINE:-0}
ADDNODES=${ADDNODES:-}
WALLET_NAME=${WALLET_NAME:-testwallet}

# Write configuration file
cat <<EOF > /bitcoin/bitcoin.conf
rpcuser=${RPCUSER}
rpcpassword=${RPCPASSWORD}
txindex=1
chain=${NETWORK}
server=1

[${NETWORK}]
rpcport=${RPCPORT}
rpcbind=0.0.0.0:${RPCPORT}
rpcallowip=0.0.0.0/0
wallet=testwallet
fallbackfee=0.00005
EOF

IFS=' ' read -r -a ADDNODE_ARRAY <<< "$ADDNODES"
for node in "${ADDNODE_ARRAY[@]}"; do
  echo "addnode=$node" >> /bitcoin/bitcoin.conf
done

# Start bitcoind
./bitcoin-27.0/bin/bitcoind -datadir=/bitcoin &




if ! ./bitcoin-27.0/bin/bitcoin-cli -datadir=/bitcoin -rpcuser=${RPCUSER} -rpcpassword=${RPCPASSWORD} -rpcwait listwallets | grep -q "\"${WALLET_NAME}\""; then
  echo "Creating wallet ${WALLET_NAME}"
  ./bitcoin-27.0/bin/bitcoin-cli -datadir=/bitcoin -rpcuser=${RPCUSER} -rpcpassword=${RPCPASSWORD} createwallet ${WALLET_NAME} || true
  
else
  echo "Loading wallet ${WALLET_NAME}"
  ./bitcoin-27.0/bin/bitcoin-cli -datadir=/bitcoin -rpcuser=${RPCUSER} -rpcpassword=${RPCPASSWORD} loadwallet ${WALLET_NAME} || true
fi
if [ "$MINE" -eq 1 ]; then
  sleep 5
  blocks=$(./bitcoin-27.0/bin/bitcoin-cli -datadir=/bitcoin -rpcuser=${RPCUSER} -rpcpassword=${RPCPASSWORD} -rpcport=${RPCPORT} getblockchaininfo | tee | jq '.blocks')
  echo "blocks $blocks"
  if [ "$blocks" -eq 0 ]; then
    ./bitcoin-27.0/bin/bitcoin-cli -datadir=/bitcoin -rpcuser=${RPCUSER} -rpcpassword=${RPCPASSWORD} -rpcport=${RPCPORT} -generate 120  
  fi
fi
# Function to mine blocks if MINE=1
mine_blocks() {
    sleep 5
    while true; do
        if [ "$MINE" -eq 1 ]; then
          size=$(./bitcoin-27.0/bin/bitcoin-cli -datadir=/bitcoin -rpcuser=${RPCUSER} -rpcpassword=${RPCPASSWORD} -rpcport=${RPCPORT} getmempoolinfo  |tee| jq '.size')

          if [[ "$size" -ne 0 ]]; then
            echo "Gonna mine!"
            ./bitcoin-27.0/bin/bitcoin-cli -datadir=/bitcoin -rpcuser=${RPCUSER} -rpcpassword=${RPCPASSWORD} -rpcport=${RPCPORT} -generate 2
          fi
        fi
        sleep 2
    done
}

# Run the mine_blocks function in the background
mine_blocks &

# Wait for bitcoind to exit
wait $!