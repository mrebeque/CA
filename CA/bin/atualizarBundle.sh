#!/bin/bash
# Autor: Marcelo Rebeque
# Data de criação: 07/03/2025
# Data de atualização: 07/03/2025
# Versão: 0.01  
# Dependencias: openssl, attr, dos2unix

. $WORKCA/resources/resource.env

DATA_HORA_ATUAL=$(date +"%d/%m/%Y %H:%M:%S")
HTTPADDR_DATA=https://www.gov.br/iti/pt-br/assuntos/repositorio/certificados-das-acs-da-icp-brasil-arquivo-unico-compactado
HTTPADDR=http://acraiz.icpbrasil.gov.br/credenciadas/CertificadosAC-ICP-Brasil/ACcompactado.zip
PATH_CA_SEFAZRJ=$DIR_CA_ATIVA/sefazrj-ca.crt
PATH_DIST_BUNDLE=$DIR_CA_ATIVA/bundle-icp-brasil.crt
ARQ_REG_UPDATE=$DIR_CA_ATIVA/UPD_BUNLE_$DATA_HORA_ATUAL.txt

DEST=./icpbrasil
FILE=bundle-icp-brasil.crt
FLG_PROCESSA=0
DATA_LOCALFILE=""

DATA_WEBFILE=$(wget -qO- "$HTTPADDR_DATA" | grep "Atualizado em:" | awk -Fem: '{print $2}' | awk -F. '{print $1}' | xargs)

if [ -f "$FILE" ] && [ -r "$FILE" ]; then
  DATA_LOCALFILE=$(getfattr -n user.version_data --only-values $FILE)
  if [[ "$DATA_LOCALFILE" != "$DATA_WEBFILE" ]]; then
    FLG_PROCESSA=1
  fi
else
  FLG_PROCESSA=1
fi

if [[ "$FLG_PROCESSA" == "1" ]]; then

  mkdir -p ${DEST}
  cd ${DEST}

  wget -q "$HTTPADDR"

  unzip -q *.zip

  for fn in $(file *.crt|grep data|sed 's/: *data//')
  do
    mv $fn  $fn.der
    openssl x509 -inform der -in $fn.der -out $fn
  done

  for f in $(ls *.crt); do
    dos2unix -q $f
    openssl x509 -text -in $f >> $FILE
  done
  
  # Adicioanr certificado CA SEFAZRJ
  openssl x509 -text -in $PATH_CA_SEFAZRJ >> $FILE

  cp $FILE $PATH_DIST_BUNDLE  
  
  setfattr -n user.version_data -v "$DATA_WEBFILE" $PATH_DIST_BUNDLE
  
  echo "Bundle atualizado às: $DATA_HORA_ATUAL" > $ARQ_REG_UPDATE
  rm -r ../${DEST}
fi

