# MegaCoin RPC Server - Run Docker Image

## Adding firewall rules
Open needed ports on your docker host server.
```
ufw logging on
ufw allow 22/tcp
ufw limit 22/tcp
ufw allow 8555/tcp
ufw allow 40332/tcp
ufw default deny incoming 
ufw default allow outgoing 
yes | ufw enable
```

## Pull docker image
```
docker pull <repository>/mec-rpc-server
```

## Run docker container
```
docker run -p 40332:40332 -p 8555:8555 -p 9051:9051 --name mec-rpc-server -e MECPWD='NEW_MEC_PWD' -v /home/megacoin:/home/megacoin:rw -d <repository>/mec-rpc-server
docker ps
```

## Debbuging within a container (after start.sh execution)
Please execute ```docker run``` without option ```--entrypoint bash``` before you execute this commands:
```
tail -f /home/megacoin/.megacoin/debug.log

docker ps
docker exec -it mec-rpc-server bash
  # you are inside the mc-rpc-server container
  root@container# supervisorctl status megacoind
  root@container# cat /var/log/supervisor/supervisord.log
  # Change to megacoin user
  root@container# sudo su megacoin
  megacoin@container# cat /home/megacoin/.megacoin/debug.log
  megacoin@container# megacoin-cli getinfo
```

## Debbuging within a container during run (skip start.sh execution)
```
docker run -p 40332:40332 -p 8555:8555 -p 9051:9051 --name mec-rpc-server -e MECPWD='NEW_MEC_PWD' -v /home/megacoin:/home/megacoin:rw --entrypoint bash <repository>/mec-rpc-server
```

## Stop docker container
```
docker stop mec-rpc-server
docker rm mec-rpc-server
```
