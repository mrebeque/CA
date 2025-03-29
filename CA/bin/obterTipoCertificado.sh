#!/bin/bash
# Nome: obterTipoCertificado.sh  
# Sintaxe: obterTipoCertificado.sh  <NOme do arquivo da solicitação>
# Exemplo: obterTipoCertificado.sh  /work/ca/solicitacoes/rpsys-ca.req

nomeArquivo=$1
retorno=""
validarArquivoSolicitacao.sh "$nomeArquivo"
codRet=$?
if [ $codRet -gt 0 ]; then
  echo "Erro validação do arquivo de solicitação: $nomeArquivo ."
  exit $codRet
fi 

while IFS='=' read -r chave valor; do
  # Ignora linhas vazias e comentários (que começam com #)
  if [[ -n "$chave" && "$chave" != \#* ]]; then	  
		chaveUpperCase=$(echo "$chave" | tr '[:lower:]' '[:upper:]')
		
		if [[ "$chaveUpperCase" = "TIPO" ]]; then
		  retorno=$(echo "$valor" | tr '[:lower:]' '[:upper:]')

		fi
  fi
done < "$nomeArquivo"
echo "$retorno"

