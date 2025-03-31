sudo docker stop ca-manager
echo "Aguardando remoção do container !"
sleep 3
sudo docker run -d \
  --name ca-manager \
  --hostname server-ca \
  --rm \
  -p 8080:80 \
  -p 8443:443 \
  -v solicitacoes_certificados:/opt/ca/solicitacoes \
  -v solicitacoes_processadas:/opt/ca/processadas \
  -v certificados_emitidos:/opt/ca/emitidos \
  -v templates_solicitacoes:/opt/ca/templates \
  -v ca_ativa:/opt/ca/ca-ativa \
  -v bundle:/opt/ca/bundle \
  localhost/ca-manager:3.0
  
sleep 2  
sudo docker logs ca-manager

sudo docker ps  -a 

sudo docker exec -it ca-manager  /bin/bash
