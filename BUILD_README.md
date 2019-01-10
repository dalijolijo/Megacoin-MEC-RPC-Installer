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
docker build -t mec-rpc-server --build-arg VERSION=0.15.0.5 --build-arg RELEASE_TAR=linux.Ubuntu.16.04.LTS-static-libstdc.tar.gz .
```

## Push docker image to hub.docker
```
docker tag mec-rpc-server limxtec/mec-rpc-server
docker login -u limxtec -p"<PWD>"
docker push limxtec/mec-rpc-server:<tag>
```
