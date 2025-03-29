#!/bin/bash
#
docker volume rm autoridades
docker volume create \
  --driver local \
  --opt type=none \
  --opt device=/work/container/ca-manager/storage/autoridades \
  --opt o=bind \
autoridades

docker volume rm bundle
docker volume create \
  --driver local \
  --opt type=none \
  --opt device=/work/container/ca-manager/storage/bundle \
  --opt o=bind \
bundle

docker volume rm ca_ativa
docker volume create \
  --driver local \
  --opt type=none \
  --opt device=/work/container/ca-manager/storage/ca-ativa \
  --opt o=bind \
ca_ativa

docker volume rm certificados_emitidos
docker volume create \
  --driver local \
  --opt type=none \
  --opt device=/work/container/ca-manager/storage/emitidos \
  --opt o=bind \
certificados_emitidos

docker volume rm solicitacoes_processadas
docker volume create \
  --driver local \
  --opt type=none \
  --opt device=/work/container/ca-manager/storage/processadas \
  --opt o=bind \
solicitacoes_processadas

docker volume rm solicitacoes_certificados 
docker volume create \
  --driver local \
  --opt type=none \
  --opt device=/work/container/ca-manager/storage/solicitacoes \
  --opt o=bind \
solicitacoes_certificados

docker volume rm templates_solicitacoes
docker volume create \
  --driver local \
  --opt type=none \
  --opt device=/work/container/ca-manager/storage/templates \
  --opt o=bind \
templates_solicitacoes

docker volume rm usuarios
docker volume create \
  --driver local \
  --opt type=none \
  --opt device=/work/container/ca-manager/storage/usuarios \
  --opt o=bind \
usuarios

