sudo docker stop ubuntu-ca
sudo docker rm ubuntu-ca

sudo docker run -d \
  --name ubuntu-ca \
  ubuntu-ca:1.0
  
sleep 2  
sudo docker logs ubuntu-ca

sudo docker ps  -a 

sudo docker exec -it ubuntu-ca  /bin/bash
