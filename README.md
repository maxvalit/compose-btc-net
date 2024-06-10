# Docker Compose BTC Net

* 3 BTC RegTest Nodes.  RPC ports :8332 :18332 :28332. Miner node (:18332) mines one block in 10 sec
* Wallets for each node :9998 :19998 :29998
* Explorer :29988

```
# git clone ...
git submodules init
git submodules update --remote

docker compose up
```
