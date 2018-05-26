# MegaCoin RPC Server - Dockerfile (05-2018)
#
# This Dockerfile will install all required stuff to run a MegaCoin RPC Server.
# MegaCoin Repo : https://github.com/LIMXTEC/Megacoin
# 
# To build a docker image for mec-rpc-server from the Dockerfile the megacoin.conf is also needed.
# See BUILD_README.md for further steps.

# Use an official Ubuntu runtime as a parent image
FROM ubuntu:16.04

LABEL maintainer="Jon D. (dArkjON), David B. (dalijolijo)"
LABEL version="0.1"

# Make ports available to the world outside this container
EXPOSE 8555 9051 40332

USER root

# Change sh to bash
SHELL ["/bin/bash", "-c"]

# Define environment variable
ENV MECPWD "megacoin"

RUN echo '*** MegaCoin MEC RPC Server ***'

# Creating megacoin user
RUN echo '*** Step 1/10 - creating megacoin user ***' && \
    adduser --disabled-password --gecos "" megacoin && \
    usermod -a -G sudo,megacoin megacoin && \
    echo megacoin:$MECPWD | chpasswd

# Running updates and installing required packages
RUN echo '*** Running updates and installing required packages ***' && \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y  apt-utils \
                        autoconf \
                        automake \
                        autotools-dev \
                        build-essential \
                        curl \
                        git \
                        libboost-all-dev \
                        libevent-dev \
                        libminiupnpc-dev \
                        libssl-dev \
                        libtool \
                        libzmq5-dev \
                        pkg-config \
                        software-properties-common \
                        sudo \
                        supervisor \
                        vim \
                        wget && \
    add-apt-repository -y ppa:bitcoin/bitcoin && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y  libdb4.8-dev \
                        libdb4.8++-dev

# Cloning and Compiling MegaCoin Wallet
RUN echo '*** Cloning and Compiling MegaCoin Wallet ***' && \
    cd && \
    echo "Execute a git clone of LIMXTEC/Megacoin. Please wait..." && \
    git clone https://github.com/LIMXTEC/Megacoin.git && \
    cd Megacoin && \
    ./autogen.sh && \
    ./configure --disable-dependency-tracking --enable-tests=no --without-gui --disable-hardening && \
    make && \
    cd && \
    cd Megacoin/src && \
    strip megacoind && \
    cp megacoind /usr/local/bin && \
    strip megacoin-cli && \
    cp megacoin-cli /usr/local/bin && \
    chmod 775 /usr/local/bin/megacoin* && \
    cd && \
    rm -rf Megacoin

# Configure megacoin.conf	
COPY megacoin.conf /tmp	
RUN echo '*** Configure megacoin.conf ***' && \	
    chown megacoin:megacoin /tmp/megacoin.conf && \	
    sudo -u megacoin mkdir -p /home/megacoin/.megacoin && \	
    sudo -u megacoin cp /tmp/megacoin.conf /home/megacoin/.megacoin/megacoin.conf

# Copy Supervisor Configuration
COPY *.sv.conf /etc/supervisor/conf.d/

# Logging outside docker container
VOLUME /var/log

# Copy start script
RUN echo '*** Copy start script ***'
COPY start.sh /usr/local/bin/start.sh
RUN rm -f /var/log/access.log && mkfifo -m 0666 /var/log/access.log && \
    chmod 755 /usr/local/bin/*

ENV TERM linux
CMD ["/usr/local/bin/start.sh"]
