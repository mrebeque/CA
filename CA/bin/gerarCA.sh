#!/bin/bash
# Nome: gerarCA.sh  
# Sintaxe: gerarCA.sh  <NOme do arquivo da solicitação>
# Exemplo: gerarCA.sh  /work/ca/solicitacoes/rpsys-ca.req

# . "$DIR_RESOURCES"/env.sh
arquivo="$1"

if [[ $(obterTipoCertificado.sh $arquivo) != "CA" ]]; then 
  echo "O Tipo do certificado solicitado é inválido. Tipos válidos: ECPF / ECNPJ / SERVER-WEB / CA"
  exit 1
fi

# TIPO= ECPF / ECNPJ / SERVER-WEB / CA
tipo=""
ca_municipio=""
ca_organizacao=""
ca_departamento=""
ca_nome_ca=""
ca_email=""

nome_certificado=$(basename "$arquivo" .req)
dir_certficado="$CAdir"/"$nome_certificado"
mkdir -p "$dir_certficado"

arq_configuracao="$dir_certficado"/"$nome_certificado".conf
cp -p "$template_ca" "$arq_configuracao"

cp -p $arquivo "$dir_certficado"/
arq_request="$dir_certficado"/"$nome_certificado".req

while IFS='=' read -r chave valor; do
	# Ignora linhas vazias e comentários (que começam com #)
	if [[ -n "$chave" && "$chave" != \#* ]]; then

		chaveUpperCase=$(echo "$chave" | tr '[:lower:]' '[:upper:]')
		if [[ "$chaveUpperCase" = "MUNICIPIO" ]]; then
			ca_municipio=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
		elif [[ "$chaveUpperCase" = "ORGANIZACAO" ]]; then
			ca_organizacao=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
		elif [[ "$chaveUpperCase" = "DEPARTAMENTO" ]]; then
			ca_departamento=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
		elif [[ "$chaveUpperCase" = "NOME_CA" ]]; then
			ca_nome_ca=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
		elif [[ "$chaveUpperCase" = "EMAIL" ]]; then
			ca_email=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
		elif [[ "$chaveUpperCase" = "TIPO" ]]; then
			tipo=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
		fi
	fi
done < "$arq_request"


atualizarConfiguracaoCA.sh "$ca_municipio" \
                         "$ca_organizacao" \
                         "$ca_departamento" \
                         "$ca_nome_ca" \
                         "$ca_email" \
                         "$arq_configuracao" 
codRet=$?

if [ $codRet -gt 0 ]; then
  echo "Erro na construção do arquivo de configuração $arq_configuracao ." 
  exit $codRet
fi 

gerarCertificadoCA.sh "$dir_certficado" "$nome_certificado" "$arq_configuracao"
codRet=$?

if [ $codRet -gt 0 ]; then
  echo "Erro na geração do certificado $nome_certificado ." 
  exit $codRet
fi 

exit 0



