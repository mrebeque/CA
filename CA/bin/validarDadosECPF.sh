#!/bin/bash

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

idpes=$(tr -dc '0-9' < /dev/urandom | head -c 4)

if [[ -z $MUNICIPIO ]]; then
    MUNICIPIO="Rio de Janeiro"     
fi

if [[ -z $NOME ]]; then
    NOME="Joao-$idpes da Silva."
fi
//
//

if [[ -z $CPF ]]; then
   gravarLog.sh "Error na validação dos dados. O campo CPF é obrigatório." "ERROR" "" 
  exit 1 
fi

if [[ -z $EMAIL ]]; then
   EMAIL="Joao$idpes@gmail.com"
fi

if [[ -z $DT_NASCIMENTO_RESP ]]; then
   DT_NASCIMENTO_RESP="00000000" 
fi

if [[ -z $RG ]]; then
   RG="123456789012345"
fi

if [[ -z $ORGAO_RG ]]; then
   ORGAO_RG="DETRAN"
fi

if [[ -z $UF_RG ]]; then
   UF_RG="RJ"
fi

if [[ -z $INSS ]]; then
   INSS="123456789012"
fi

if [[ -z $NIS ]]; then
   NIS="12345678901"
fi

exit 0
     
