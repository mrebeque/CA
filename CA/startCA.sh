#!/bin/bash
# Nome: startCA.sh  

arq_env=${1}

if [[ -z "${arq_env}" ]]; then
   echo "ERROR: Parâmetro não informado. O nome do arquivo de variaveis de ambiente é obrigatório."
   exit 1
fi 
if [[ ! -e $arq_env ]]; then
  echo "ERROR: Arquivo de variaveis de ambiente não encontrado: $arq_env !"
  exit 1
fi
. "$arq_env"

export PATH="$WORKCA:$WORKCA/bin:${PATH}"

# Criar e configurar permissões na estrutura de pastas de apoio para a execução da app.
#
confCA.sh

# Iniciar o agendamento de atualização do BUNDLE
#
nohup agendarAtualizacaoBundle.sh &

# Iniciar a rotina de assinatura de certificados.
#
initCA.sh

#codRet=$?

