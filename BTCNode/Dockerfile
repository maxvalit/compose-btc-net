FROM ubuntu:latest 
WORKDIR /BTCNode


ENV CONNECT=''

RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    wget
#ENV RPC_PORT=4033
RUN wget -qO- https://bitcoin.org/bin/bitcoin-core-27.0/bitcoin-27.0-x86_64-linux-gnu.tar.gz | tar xvz -C .

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the Bitcoin ports
EXPOSE 8332 8333 18332 18333 28332 28333


# Set the entrypoint
ENTRYPOINT ["bash","/usr/local/bin/entrypoint.sh"]

# Default command
CMD ["./bitcoin-27.0/bin/bitcoind", "-datadir=/bitcoin"]