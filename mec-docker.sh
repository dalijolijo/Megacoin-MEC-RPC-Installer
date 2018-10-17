#!/bin/bash
set -u

GIT_REPO="dalijolijo"
DOCKER_REPO="dalijolijo"
GIT_PROJECT="Megacoin-MEC-RPC-Installer"
DOCKER_REPO="dalijolijo"
IMAGE_NAME="mec-rpc-server"
IMAGE_TAG="0.15.0.5" #MEC Version 0.15.0.5
CONFIG_PATH="/home/megacoin/.megacoin"
CONFIG=${CONFIG_PATH}/megacoin.conf
CONTAINER_NAME="mec-rpc-server"
DEFAULT_PORT="7951"
RPC_PORT="7952"
TOR_PORT="9051"
WEB="megacoin.eu/downloads" # without "https://" and without the last "/" (only HTTPS accepted)
BOOTSTRAP="bootstrap.tar.gz"

#
# Color definitions
#
RED='\033[0;31m'
GREEN='\033[0;32m'
NO_COL='\033[0m'
MEC_COL='\033[1;31m'

#
# Check if megacoin.conf already exist.
#
clear
REUSE="No"
printf "\nDOCKER SETUP FOR ${MEC_COL}MEGACOIN (MEC) v.{IMAGE_TAG}${NO_COL} RPC SERVER\n"
if [ -f "$CONFIG" ]
then
	printf "\nSetup Config file"
        printf "\n-----------------"
	printf "\nFound $CONFIG on your system.\n"
        printf "\nDo you want to re-use this existing config file?\n" 
        printf "Enter [Y]es or [N]o and Hit [ENTER]: "
        read REUSE
fi

if [[ $REUSE =~ "Y" ]] || [[ $REUSE =~ "y" ]]; then
        source $CONFIG
	cp ${CONFIG_PATH}/megacoin.conf ${CONFIG_PATH}/.megacoin.conf
fi

#
# Docker Installation
#
if ! type "docker" > /dev/null; then
    curl -fsSL https://get.docker.com | sh
fi

#
# Firewall Setup
#
printf "\nDownload needed Helper-Scripts"
printf "\n------------------------------\n"
wget https://raw.githubusercontent.com/${GIT_REPO}/${GIT_PROJECT}/master/check_os.sh -O check_os.sh
chmod +x ./check_os.sh
source ./check_os.sh
rm ./check_os.sh
wget https://raw.githubusercontent.com/${GIT_REPO}/${GIT_PROJECT}/master/firewall_config.sh -O firewall_config.sh
chmod +x ./firewall_config.sh
source ./firewall_config.sh ${DEFAULT_PORT} ${RPC_PORT} ${TOR_PORT}
rm ./firewall_config.sh

#
# Pull docker images and run the docker container
#
printf "\nStart Docker container"
printf "\n----------------------\n"
sudo docker ps | grep ${CONTAINER_NAME} >/dev/null
if [ $? -eq 0 ];then
    printf "${RED}Conflict! The container name \'${CONTAINER_NAME}\' is already in use.${NO_COL}\n"
    printf "\nDo you want to stop the running container to start the new one?\n"
    printf "Enter [Y]es or [N]o and Hit [ENTER]: "
    read STOP

    if [[ $STOP =~ "Y" ]] || [[ $STOP =~ "y" ]]; then
        docker stop ${CONTAINER_NAME}
    else
	printf "\nDocker Setup Result"
        printf "\n----------------------\n"
        printf "${RED}Canceled the Docker Setup without starting ${MEC_COL}Megacoin${RED} RPC Server Docker Container.${NO_COL}\n\n"
	exit 1
    fi
fi
docker rm ${CONTAINER_NAME} >/dev/null
docker pull ${DOCKER_REPO}/${IMAGE_NAME}:${IMAGE_TAG}
docker run --rm \
 -p ${DEFAULT_PORT}:${DEFAULT_PORT} \
 -p ${RPC_PORT}:${RPC_PORT} \
 -p ${TOR_PORT}:${TOR_PORT} \
 --name ${CONTAINER_NAME} \
 -e WEB="${WEB}" \
 -e BOOTSTRAP="${BOOTSTRAP}" \
 -e CONFIG_PATH=${CONFIG_PATH} \
 -v /home/megacoin:/home/megacoin:rw \
 -d ${DOCKER_REPO}/${IMAGE_NAME}:${IMAGE_TAG}

#
# Show result and give user instructions
#
sleep 3
clear
printf "\nDocker Setup Result"
printf "\n----------------------\n"
sudo docker ps | grep ${CONTAINER_NAME} >/dev/null
if [ $? -ne 0 ];then
    printf "${RED}Sorry! Something went wrong. :(${NO_COL}\n"
else
    printf "${GREEN}GREAT! Your ${MEC_COL}Megacoin${GREEN} RPC Server Docker Container is running now! :)${NO_COL}\n"
    printf "\nShow your running docker container \'${CONTAINER_NAME}\' with 'docker ps'\n"
    sudo docker ps | grep ${CONTAINER_NAME}
    printf "\nJump inside the ${MEC_COL}Megacoin (MEC)${NO_COL} RPC-Server Docker Container with 'docker exec -it ${CONTAINER_NAME} bash'\n"
    printf "\nCheck Log Output of ${MEC_COL}Megacoin (MEC)${NO_COL} RPC-Server with ${GREEN}'docker logs ${CONTAINER_NAME}'${NO_COL}\n"
    printf "${GREEN}HAVE FUN!${NO_COL}\n\n"
fi
