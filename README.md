# Docker Compose BTC Net

* 3 BTC RegTest Nodes.  RPC ports :8332 :18332 :28332. Miner node (:8332) mines 120 blocks on startup (to provide initial coins supply) and 2 blocks when mempool has >0 tx, checking it every 3 seconds.
* Wallets for each node :9998 :19998 :29998
* Explorer :29988

```
# git clone ...
git submodules init
git submodules update --remote

docker compose up
```
