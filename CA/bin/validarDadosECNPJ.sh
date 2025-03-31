#!/bin/bash

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

idEmp=$(tr -dc '0-9' < /dev/urandom | head -c 4)

if [[ -z $MUNICIPIO ]]; then
    MUNICIPIO="Rio de Janeiro"     
fi

if [[ -z $RAZAO_SOCIAL ]]; then
    RAZAO_SOCIAL="Emp-$idEmp Ltda."
fi

if [[ -z $DEPARTAMENTO ]]; then
    DEPARTAMENTO="T.I."
fi

if [[ -z $CNPJ ]]; then
   gravarLog.sh "Error na validação dos dados. O campo CNPJ é obrigatório." "ERROR" ""
   exit 1
fi

if [[ -z $EMAIL ]]; then
   EMAIL="$CNPJ@emp-$idEmp.com.br"
fi

if [[ -z $INSS ]]; then
   INSS="123456789012"
fi

if [[ -z $CPF_RESP ]]; then
   gravarLog.sh "Error na validação dos dados. O campo CPF do responsável é obrigatório." "ERROR" "" 
  exit 1
fi

if [[ -z $DT_NASCIMENTO_RESP ]]; then
   DT_NASCIMENTO_RESP="00000000" 
fi

if [[ -z $RG_RESP ]]; then
   RG_RESP="123456789012345"
fi

if [[ -z $ORGAO_RG_RESP ]]; then
   ORGAO_RG_RESP="DETRAN"
fi

if [[ -z $UF_RG_RESP ]]; then
   UF_RG_RESP="RJ"
fi

if [[ -z $NIS_RESP ]]; then
   NIS_RESP="12345678901"
fi

exit 0
     
