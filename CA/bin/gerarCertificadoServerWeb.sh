#!/bin/bash
# Nome: gerarCertificadoServerWeb.sh  
# Sintaxe: gerarCertificadoServerWeb.sh  <NOme do arquivo da solicitação>
# Exemplo: gerarCertificadoServerWeb.sh  /work/ca/solicitacoes/11806650746-cert.req
# . "$DIR_RESOURCES"/env.sh
arquivo="$1"

if [[ $(obterTipoCertificado.sh $arquivo) != "SERVER-WEB" ]]; then 
  echo "O Tipo do certificado solicitado é inválido. Tipos válidos: ECPF / ECNPJ / SERVER-WEB / CA"
  exit 1
fi

# TIPO=ECPF / ECNPJ / SERVER-WEB / CA
tipo=""
sw_municipio=""
sw_organizacao=""
sw_departamento=""
sw_email=""
sw_dominio_web=""
sw_host_name=""

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
			sw_departamento="$valor"
		elif [[ "$chaveUpperCase" = "EMAIL" ]]; then
			sw_email=$(echo "$valor" | tr '[:upper:]' '[:lower:]')
		elif [[ "$chaveUpperCase" = "DOMINIO_WEB" ]]; then
			sw_dominio_web=$(echo "$valor" | tr '[:upper:]' '[:lower:]')
		elif [[ "$chaveUpperCase" = "HOST_NAME" ]]; then
			sw_host_name=$(echo "$valor" | tr '[:upper:]' '[:lower:]')
		elif [[ "$chaveUpperCase" = "TIPO" ]]; then
			tipo=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
		fi
	fi
done < "$arq_request"
                       
atualizarConfiguracaoServerWeb.sh "$sw_municipio" \
                         "$sw_organizacao" \
                         "$sw_departamento" \
                         "$sw_email" \
                         "$sw_dominio_web" \
                         "$sw_host_name" \
                         "$arq_configuracao" 
codRet=$?
if [ $codRet -gt 0 ]; then
#  echo "Erro na construção do arquivo de configuração $arq_configuracao ." 
  gravarLog.sh "Erro na construção do arquivo de configuração $arq_configuracao ." "ERROR" "" 
  
  exit $codRet
fi 

gerarCertificado.sh "$dir_certficado" "$nome_certificado" "$arq_configuracao"	
codRet=$?

if [ $codRet -gt 0 ]; then
  gravarLog.sh "Erro na geração do certificado $nome_certificado ." "ERROR" "" 
#  echo "Erro na geração do certificado $nome_certificado ." 
  exit $codRet
fi 

exit 0



