#!/bin/bash
# Nome: gravarog.sh  
# Sintaxe: gravarLog.sh  <Mensagem> <status=(ERROR,WARN,INFO)> <path do arqivo log>
# Exemplo: gravarLog.sh  "Certificado gerado com sucesso" "INFO" "/opt/ca/logs/ca-manager.log"

#. "$DIR_RESOURCES"/env.sh

mensagem=${1}
status=${2}
arquivo_log=${3}

data_hora=$(date +"%d/%m/%Y %H:%M")
dsStatus=$(echo "$status" | tr '[:lower:]' '[:upper:]')

if [ -n "$arquivo_log" ]; then
  if [ ! -f "$arquivo_log" ]; then
      echo "# Logs do dia $data_hora " > "$arquivo_log" 
      echo "#" >> "$arquivo_log" 
  fi
  # Envia log para o arquivo
  echo "$data_hora - $dsStatus : $mensagem" >> "$arquivo_log"
fi

# Envia log para o Console
echo "$data_hora - $dsStatus : $mensagem"
