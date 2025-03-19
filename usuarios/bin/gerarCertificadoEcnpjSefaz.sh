#!/bin/bash

source /work/ca/resources/env.sh
source /work/ca/resources/libs.sh

# TIPO=ECPF / ECNPJ / SERVER-WEB / CA
tipo=""
ecnpj_municipio=""
ecnpj_razao_social=""
ecnpj_departamento=""
ecnpj_cnpj=""
ecnpj_email=""
ecnpj_inss=""
ecnpj_cpf_resp=""
ecnpj_dt_nascimento_resp=""
ecnpj_rg_resp=""
ecnpj_orgao_rg_resp=""
ecnpj_uf_rg_resp=""
ecnpj_nis_resp=""
	
# Verifica se o arquivo foi passado como argumento
if [ -z "$1" ]; then
  echo "Error : $0 arquivo de requsição de certificado não existe."
  exit 1
fi


# Armazena o caminho do arquivo
arquivo="$1"
extensaoArquivo="${arquivo##*.}"
if [[ "$extensaoArquivo" != "req" ]]; then 
   echo "O arquivo de configuração inválido! Precisa ser da extensão REQ ."
   exit 1
fi

tipoCert=$(obter_tipo $arquivo)
nomeCertificado=$(basename "$arquivo" .req)

if [[ "$tipoCert" = "ECNPJ" ]]; then 

	nome_certificado=$(basename "$arquivo" .req)
	data_hora=$(date +"%Y%m%d%H%M")
	dir_certficado="$usuarioDir"/"$nome_certificado"/"$data_hora"
  arq_configuracao="$dir_certficado"/"$nome_certificado".conf

  
	mkdir -p $dir_certficado 
	cp -p "$template_ecnpj_sefaz" "$arq_configuracao"
	cp -p $arquivo "$dir_certficado"

	arq_request="$dir_certficado"/"$nome_certificado".req

	while IFS='=' read -r chave valor; do
		# Ignora linhas vazias e comentários (que começam com #)
		if [[ -n "$chave" && "$chave" != \#* ]]; then

			chaveUpperCase=$(echo "$chave" | tr '[:lower:]' '[:upper:]')
			if [[ "$chaveUpperCase" = "MUNICIPIO" ]]; then
				ecnpj_municipio=$(echo "$valor" | tr '[:lower:]' '[:upper:]')	
			elif [[ "$chaveUpperCase" = "RAZAO_SOCIAL" ]]; then
				ecnpj_razao_social=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "DEPARTAMENTO" ]]; then
				ecnpj_departamento=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "CNPJ" ]]; then
				ecnpj_cnpj=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "EMAIL" ]]; then
				ecnpj_email=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "INSS" ]]; then
				ecnpj_inss=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "CPF_RESP" ]]; then
				ecnpj_cpf_resp=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "DT_NASCIMENTO_RESP" ]]; then
				ecnpj_dt_nascimento_resp=$(echo "$valor" | tr '[:lower:]' '[:upper:]')				
			elif [[ "$chaveUpperCase" = "RG_RESP" ]]; then
				ecnpj_rg_resp=$(echo "$valor" | tr '[:lower:]' '[:upper:]')				
			elif [[ "$chaveUpperCase" = "ORGAO_RG_RESP" ]]; then
				ecnpj_orgao_rg_resp=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "UF_RG_RESP" ]]; then
	    	ecnpj_uf_rg_resp=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			elif [[ "$chaveUpperCase" = "NIS_RESP" ]]; then
	    	ecnpj_nis_resp=$(echo "$valor" | tr '[:lower:]' '[:upper:]')	    	
			elif [[ "$chaveUpperCase" = "TIPO" ]]; then
				tipo=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
			fi
		fi
	done < "$arq_request"

	./atualizarConfiguracaoECNPJ.sh "$ecnpj_municipio" \
	                         "$ecnpj_razao_social" \
	                         "$ecnpj_departamento" \
	                         "$ecnpj_cnpj" \
	                         "$ecnpj_email" \
	                         "$ecnpj_inss" \
	                         "$ecnpj_cpf_resp" \
	                         "$ecnpj_dt_nascimento_resp" \
	                         "$ecnpj_rg_resp" \
	                         "$ecnpj_orgao_rg_resp" \
	                         "$ecnpj_uf_rg_resp" \
	                         "$ecnpj_nis_resp" \
	                         "$arq_configuracao" 
	
	./gerarCertificado.sh "$dir_certficado" "$nome_certificado" "$arq_configuracao"	
else
  echo "O Tipo $tipo é inválido."
fi
exit 0



