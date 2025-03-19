#!/bin/bash
source /work/ca/resources/env.sh

MUNICIPIO=${1}
ORGANIZACAO=${2}
DEPARTAMENTO=${3}
NOME_CA=${4}
EMAIL=${5}
arquivo_conf=${6}

CLR="$url_clr"
MD="$algoritmo_ass"
DIA_EXPIRAR="$qtde_dias_ca"


# Ler o arquivo e substituir as tags
sed -e "s|{{MUNICIPIO}}|$MUNICIPIO|g" \
    -e "s|{{ORGANIZACAO}}|$ORGANIZACAO|g" \
    -e "s|{{DEPARTAMENTO}}|$DEPARTAMENTO|g" \
    -e "s|{{NOME_CA}}|$NOME_CA|g" \
    -e "s|{{EMAIL}}|$EMAIL|g" \
    -e "s|{{ALGORITMO_ASSINATURA}}|$MD|g" \
    -e "s|{{QTD_DIAS_EXPIRAR}}|$DIA_EXPIRAR|g" \
    -e "s|{{URL}}|$CLR|g" \
    "$arquivo_conf" > temp.txt && \
     mv temp.txt "$arquivo_conf" && \
     rm -f tmp.txt
     
