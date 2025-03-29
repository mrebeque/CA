#!/bin/bash
# Nome: validarArquivoSolicitacao.sh  
# Sintaxe: validarArquivoSolicitacao.sh  <NOme do arquivo da solicitação>
# Exemplo: validarArquivoSolicitacao.sh  /work/ca/solicitacoes/rpsys-ca.req

nomeArquivo=$1
if [[ -z "${nomeArquivo// }" ]]; then
   echo "Erro: Parâmetro não informado. O nome do arquivo é obrigatório."
   exit 1
fi 

if [ ! -f $nomeArquivo ]; then
   echo "Erro: Arquivo $nomeArquivo não encontrado."
   exit 1
fi 

extensaoArquivo="${nomeArquivo##*.}"
if [[ "$extensaoArquivo" != "req" ]]; then 
   echo "Erro: O arquivo de configuração inválido! Precisa ser da extensão .req !"
   exit 1
fi
exit 0
