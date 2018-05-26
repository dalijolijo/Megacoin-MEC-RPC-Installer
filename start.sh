#!/bin/bash
set -u

BOOTSTRAP='bootstrap.tar.gz'

#
# Set passwd of megacoin user
#
echo megacoin:${MECPWD} | chpasswd

#
# Configure megacoin.conf
#
printf "** Configure megacoin.conf ***\n"
mkdir -p /home/megacoin/.megacoin	
chown -R megacoin:megacoin /home/megacoin/
chown megacoin:megacoin /tmp/megacoin.conf
sudo -u megacoin cp /tmp/megacoin.conf /home/megacoin/.megacoin/megacoin.conf
sed -i "s/^\(rpcuser=\).*/rpcuser=mexrpcnode${MECPWD}/" /home/megacoin/.megacoin/megacoin.conf
sed -i "s/^\(rpcpassword=\).*/rpcpassword=${MECPWD}/" /home/megacoin/.megacoin/megacoin.conf

#
# Downloading bootstrap file
#
printf "** Downloading bootstrap file ***\n"
cd /home/megacoin/.megacoin/
if [ ! -d /home/megacoin/.megacoin/blocks ] && [ "$(curl -Is https://megacoin.eu/${BOOTSTRAP} | head -n 1 | tr -d '\r\n')" = "HTTP/1.1 200 OK" ] ; then \
        sudo -u megacoin wget https://megacoin.eu/${BOOTSTRAP}; \
        sudo -u megacoin tar -xvzf ${BOOTSTRAP}; \
        sudo -u megacoin rm ${BOOTSTRAP}; \
fi

#
# Starting MegaCoin Service
#
# Hint: docker not supported systemd, use of supervisord
printf "*** Starting MegaCoin Service ***\n"
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
