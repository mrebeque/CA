#!/bin/bash
# Nome: gerarCertificadoEcnpjSefaz.sh  
# Sintaxe: gerarCertificadoEcnpjSefaz.sh  <NOme do arquivo da solicitação>
# Exemplo: gerarCertificadoEcnpjSefaz.sh  /work/ca/solicitacoes/americana.req
# . "$DIR_RESOURCES"/env.sh

arquivo="$1"

if [[ $(obterTipoCertificado.sh $arquivo) != "ECNPJ"  ]]; then
  echo "O Tipo do certificado solicitado é inválido. Tipos válidos: ECPF / ECNPJ / SERVER-WEB / CA"
  exit 1
fi

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
			ecnpj_email=$(echo "$valor" | tr '[:upper:]' '[:lower:]' )
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

validarDadosECNPJ.sh  "$ecnpj_municipio" \
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
                         "$ecnpj_nis_resp"
codRet=$?
if [ $codRet -gt 0 ]; then
  gravarLog.sh "Erro na validação dos dados do formulário de solicitação ." "ERROR" "" 
  exit $codRet
fi                          

atualizarConfiguracaoECNPJ.sh "$ecnpj_municipio" \
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
codRet=$?
if [ $codRet -gt 0 ]; then
  gravarLog.sh "Erro na construção do arquivo de configuração $arq_configuracao ." "ERROR" "" 
  exit $codRet
fi 

gerarCertificado.sh "$dir_certficado" "$nome_certificado" "$arq_configuracao"	
codRet=$?
if [ $codRet -gt 0 ]; then

  gravarLog.sh "Erro na geração do certificado $nome_certificado ." "ERROR" "" 
  exit $codRet
fi 

exit 0


