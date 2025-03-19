#!/bin/bash
source /work/ca/resources/env.sh

MUNICIPIO=${1}
RAZAO_SOCIAL=${2}
DEPARTAMENTO=${3}
CNPJ=${4}
EMAIL=${5}
INSS=${6}
CPF_RESP=${7}
DT_NASCIMENTO_RESP=${8}
RG_RESP=${9}
ORGAO_RG_RESP=${10}
UF_RG_RESP=${11}
NIS_RESP=${12}
arquivo_conf=${13}
CLR="$url_clr"

# Ler o arquivo e substituir as tags
sed -e "s|{{MUNICIPIO}}|$MUNICIPIO|g" \
    -e "s|{{RAZAO_SOCIAL}}|$RAZAO_SOCIAL|g" \
    -e "s|{{DEPARTAMENTO}}|$DEPARTAMENTO|g" \
    -e "s|{{CNPJ}}|$CNPJ|g" \
    -e "s|{{EMAIL}}|$EMAIL|g" \
    -e "s|{{INSS}}|$INSS|g" \
    -e "s|{{CPF_RESP}}|$CPF_RESP|g" \
    -e "s|{{DT_NASCIMENTO_RESP}}|$DT_NASCIMENTO_RESP|g" \
    -e "s|{{RG_RESP}}|$RG_RESP|g" \
    -e "s|{{ORGAO_RG_RESP}}|$ORGAO_RG_RESP|g" \
    -e "s|{{UF_RG_RESP}}|$UF_RG_RESP|g" \
    -e "s|{{NIS_RESP}}|$NIS_RESP|g" \
    -e "s|{{URL}}|$CLR|g" \
    "$arquivo_conf" > temp.txt && \
     mv temp.txt "$arquivo_conf" && \
     rm -f tmp.txt
     
