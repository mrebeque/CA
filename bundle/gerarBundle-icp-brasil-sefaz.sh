#!/bin/bash

# Dependencias: openssl, attr, dos2unix

HTTPADDR_DATA=https://www.gov.br/iti/pt-br/assuntos/repositorio/certificados-das-acs-da-icp-brasil-arquivo-unico-compactado
HTTPADDR=http://acraiz.icpbrasil.gov.br/credenciadas/CertificadosAC-ICP-Brasil/ACcompactado.zip
PATH_CA_SEFAZRJ=/work/ca/sefazrj/dist/sefazrj-ca.crt
PATH_DIST_BUNDLE=/work/ca/sefazrj/dist/bundle-icp-brasil.crt

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
    echo $f
  done
  
  # Adicioanr certificado CA SEFAZRJ
  openssl x509 -text -in $PATH_CA_SEFAZRJ >> $FILE
  echo "$PATH_CA_SEFAZRJ"

  cp $FILE ..
  cp $FILE $PATH_DIST_BUNDLE  
  
  setfattr -n user.version_data -v "$DATA_WEBFILE" ../$FILE
  setfattr -n user.version_data -v "$DATA_WEBFILE" $PATH_DIST_BUNDLE
      
  rm -r ../${DEST}

  echo "Arquivo criado: $FILE. Atualizacao: $DATA_WEBFILE"
else
  echo "Arquivo $FILE ja atualizado: $DATA_LOCALFILE"
fi

