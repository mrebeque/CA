#!/bin/bash

source /work/ca/resources/env.sh
source /work/ca/resources/libs.sh

# TIPO=ECPF / ECNPJ / SERVER / CA
tipo=""
ca_municipio=""
ca_organizacao=""
ca_departamento=""
ca_nome_ca=""
ca_email=""

# Verifica se o arquivo foi passado como argumento
if [ -z "$1" ]; then
  echo "Error : $0 arquivo de requsição de certificado não existe."
  exit 1
fi

# Armazena o caminho do arquivo
arquivo="$1"

extensaoArquivo="${arquivo##*.}"
if [[ "$extensaoArquivo" != "req" ]]; then 
   echo "O arquivo de configuração inválido! Precisa ser da extensão .req !"
   exit 1
fi

tipoCert=$(obter_tipo $arquivo)
if [[ "$tipoCert" = "CA" ]]; then 


	nome_certificado=$(basename "$arquivo" .req)
	dir_certficado="$CAdir"/"$nome_certificado"
	mkdir "$dir_certficado"

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
	
	
	./atualizarConfiguracaoCA.sh "$ca_municipio" \
	                         "$ca_organizacao" \
	                         "$ca_departamento" \
	                         "$ca_nome_ca" \
	                         "$ca_email" \
	                         "$arq_configuracao" 

	./gerarCertificadoCA.sh "$dir_certficado" "$nome_certificado" "$arq_configuracao"
else
  echo "O Tipo $tipo é inválido."
fi
exit 0



