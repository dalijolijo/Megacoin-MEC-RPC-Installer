# MegaCoin RPC Server - Build Docker Image

The Dockerfile will install all required stuff to run a MegaCoin RPC Server.

## Requirements
- Linux Ubuntu 16.04 LTS
- Running as docker host server (package docker-ce installed)
```
sudo curl -sSL https://get.docker.com | sh
```

## Needed files
- Dockerfile
- megacoin.conf
- megacoind.sv.conf
- start.sh

## Allocating 2GB Swapfile
Create a swapfile to speed up the building process. Recommended if not enough RAM available on your docker host server.
```
dd if=/dev/zero of=/swapfile bs=1M count=2048
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```

## Build docker image
```
docker build [--build-arg MECPWD='<megacoin user pwd>'] -t mec-rpc-server .
```

## Push docker image to hub.docker
```
docker tag mec-rpc-server <repository>/mec-rpc-server
docker login -u <repository> -p"<PWD>"
docker push <repository>/mec-rpc-server:<tag>
```