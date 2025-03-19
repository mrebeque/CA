#!/bin/bash

source /work/ca/resources/env.sh
source /work/ca/resources/libs.sh

# TIPO=ECPF / ECNPJ / SERVER-WEB / CA
tipo=""
ecpf_municipio=""
ecpf_nome=""
ecpf_cpf=""
ecpf_email=""
ecpf_data_nascimento=""
ecpf_rg=""
ecpf_orgao_rg=""
ecpf_uf_rg=""
ecpf_nis=""

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
if [[ "$tipoCert" = "ECPF" ]]; then 

	nome_certificado=$(basename "$arquivo" .req)
	data_hora=$(date +"%Y%m%d%H%M")
	dir_certficado="$usuarioDir"/"$nome_certificado"/"$data_hora"
  arq_configuracao="$dir_certficado"/"$nome_certificado".conf
  
	mkdir -p $dir_certficado 
	cp -p "$template_ecpf_sefaz" "$arq_configuracao"
	cp -p $arquivo "$dir_certficado"

	arq_request="$dir_certficado"/"$nome_certificado".req
	
	while IFS='=' read -r chave valor; do
		# Ignora linhas vazias e comentários (que começam com #)
		if [[ -n "$chave" && "$chave" != \#* ]]; then

			chaveUpperCase=$(echo "$chave" | tr '[:lower:]' '[:upper:]')
			if [[ "$chaveUpperCase" = "MUNICIPIO" ]]; then
				ecpf_municipio=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "NOME" ]]; then
				ecpf_nome=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "CPF" ]]; then
				ecpf_cpf=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "EMAIL" ]]; then
				ecpf_email=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "DT_NASCIMENTO" ]]; then
				ecpf_data_nascimento=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "RG" ]]; then
				ecpf_rg=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "ORGAO_RG" ]]; then
				ecpf_orgao_rg=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "UF_RG" ]]; then
	    	ecpf_uf_rg=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "NIS" ]]; then
	    	ecpf_nis=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "TIPO" ]]; then
				tipo=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			fi
		fi
	done < "$arq_request"
	
	./atualizarConfiguracao.sh "$ecpf_municipio" \
	                         "$ecpf_nome" \
	                         "$ecpf_cpf" \
	                         "$ecpf_email" \
	                         "$ecpf_data_nascimento" \
	                         "$ecpf_rg" \
	                         "$ecpf_orgao_rg" \
	                         "$ecpf_uf_rg" \
	                         "$ecpf_nis" \
	                         "$arq_configuracao" 

	./gerarCertificado.sh "$dir_certficado" "$nome_certificado" "$arq_configuracao"
else
  echo "O Tipo $tipo é inválido."
fi
exit 0



