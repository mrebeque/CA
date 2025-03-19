#!/bin/bash

source /work/ca/resources/env.sh
source /work/ca/resources/libs.sh

# TIPO=ECPF / ECNPJ / SERVER-WEB / CA
tipo=""
sw_municipio=""
sw_organizacao=""
sw_departamento=""
sw_email=""
sw_dominio_web=""
sw_host_name=""

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
if [[ "$tipoCert" = "SERVER-WEB" ]]; then 

	nome_certificado=$(basename "$arquivo" .req)
	data_hora=$(date +"%Y%m%d%H%M")
	dir_certficado="$usuarioDir"/"$nome_certificado"/"$data_hora"
  arq_configuracao="$dir_certficado"/"$nome_certificado".conf
  
  # Criação do diretório destino dos arquivos(crt, csr, key, p12)  gerados para atender da solicitação 
	mkdir -p $dir_certficado 

  # Seleção do template para geração do arquivo de configuração
	cp -p "$template_web_server" "$arq_configuracao"
	
	# Cópia e geração do arquivo de solicitação para o diretório do certificado
	cp -p $arquivo "$dir_certficado"
	arq_request="$dir_certficado"/"$nome_certificado".req
	
	while IFS='=' read -r chave valor; do
		# Ignora linhas vazias e comentários (que começam com #)
		if [[ -n "$chave" && "$chave" != \#* ]]; then
			chaveUpperCase=$(echo "$chave" | tr '[:lower:]' '[:upper:]')
			if [[ "$chaveUpperCase" = "MUNICIPIO" ]]; then
				sw_municipio=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "ORGANIZACAO" ]]; then
				sw_organizacao=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "DEPARTAMENTO" ]]; then
				sw_departamento=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "EMAIL" ]]; then
				sw_email=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "DOMINIO_WEB" ]]; then
				sw_dominio_web=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "HOST_NAME" ]]; then
				sw_host_name=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "TIPO" ]]; then
				tipo=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			fi
		fi
	done < "$arq_request"
                         
	./atualizarConfiguracaoServerWeb.sh "$sw_municipio" \
	                         "$sw_organizacao" \
	                         "$sw_departamento" \
	                         "$sw_email" \
	                         "$sw_dominio_web" \
	                         "$sw_host_name" \
	                         "$arq_configuracao" 

	./gerarCertificado.sh "$dir_certficado" "$nome_certificado" "$arq_configuracao"
else
  echo "O Tipo $tipo é inválido."
fi
exit 0



