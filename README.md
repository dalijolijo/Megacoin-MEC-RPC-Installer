# Megacoin-MEC-RPC-Installer
This script helps you to install a MegaCoin MEC Node as a docker container.

## Deploy as a docker container

Support for the following distribution versions:
* Fedora 7 (x86_64-centos-7)
* Fedora 26 (x86_64-fedora-26)
* Fedora 27 (x86_64-fedora-27)
* Fedora 28 (x86_64-fedora-28)
* Debian 7 (x86_64-debian-wheezy)
* Debian 8 (x86_64-debian-jessie)
* Debian 9 (x86_64-debian-stretch)
* Debian 10 (x86_64-debian-buster)
* Ubuntu 14.04 LTS (x86_64-ubuntu-trusty)
* Ubuntu 16.04 LTS (x86_64-ubuntu-xenial) - tested
* Ubuntu 17.10 (x86_64-ubuntu-artful)
* Ubuntu 18.04 LTS (x86_64-ubuntu-bionic)

### Download and execute the docker-ce installation script

Download and execute the automated docker-ce installation script - maintained by the Docker project.

```
sudo curl -sSL https://get.docker.com | sh
```

### Download and execute the script
Login as root, then do:

```
wget https://raw.githubusercontent.com/LIMXTEC/Megacoin-MEC-RPC-Installer/master/mec-docker.sh
chmod +x mec-docker.sh
./mec-docker.sh
```

### For more details to docker related stuff have a look at:
* Megacoin-MEC-RPC-Installer/BUILD_README.md
* Megacoin-MEC-RPC-Installer/RUN_README.md
