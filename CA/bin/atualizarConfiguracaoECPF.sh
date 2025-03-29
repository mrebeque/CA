#!/bin/bash
# . "$DIR_RESOURCES"/env.sh

MUNICIPIO=${1}
NOME=${2}
CPF=${3}
EMAIL=${4}
DATA_NASCIMENTO=${5}
RG=${6}
ORGAO_RG=${7}
UF_RG=${8}
NIS=${9}
INSS=${10}
arquivo_conf=${11}
CLR="$url_clr"

# Ler o arquivo e substituir as tags
sed -e "s|{{NOME}}|$NOME|g" \
    -e "s|{{MUNICIPIO}}|$MUNICIPIO|g" \
    -e "s|{{CPF}}|$CPF|g" \
    -e "s|{{EMAIL}}|$EMAIL|g" \
    -e "s|{{DT_NASCIMENTO}}|$DATA_NASCIMENTO|g" \
    -e "s|{{RG}}|$RG|g" \
    -e "s|{{ORGAO_RG}}|$ORGAO_RG|g" \
    -e "s|{{UF_RG}}|$UF_RG|g" \
    -e "s|{{NIS}}|$NIS|g" \
    -e "s|{{INSS}}|$INSS|g" \
    -e "s|{{URL}}|$CLR|g" \
    "$arquivo_conf" > "$WORKCA"/temp.txt && \
     mv "$WORKCA"/temp.txt "$arquivo_conf" && \
     rm -f "$WORKCA"/tmp.txt
 exit 0    
