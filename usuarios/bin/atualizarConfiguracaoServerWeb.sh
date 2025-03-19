#!/bin/bash
source /work/ca/resources/env.sh

MUNICIPIO=${1}
ORGANIZACAO=${2}
DEPARTAMENTO=${3}
EMAIL=${4}
DOMINIO_WEB=${5}
HOST_NAME=${6}
arquivo_conf=${7}
CLR="$url_clr"

# Ler o arquivo e substituir as tags
sed -e "s|{{MUNICIPIO}}|$MUNICIPIO|g" \
    -e "s|{{ORGANIZACAO}}|$ORGANIZACAO|g" \
    -e "s|{{DEPARTAMENTO}}|$DEPARTAMENTO|g" \
    -e "s|{{EMAIL}}|$EMAIL|g" \
    -e "s|{{DOMINIO_WEB}}|$DOMINIO_WEB|g" \
    -e "s|{{HOST_NAME}}|$HOST_NAME|g" \
    -e "s|{{URL}}|$CLR|g" \
    "$arquivo_conf" > temp.txt && \
     mv temp.txt "$arquivo_conf" && \
     rm -f tmp.txt
     
