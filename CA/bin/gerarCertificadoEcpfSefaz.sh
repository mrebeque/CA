#!/bin/bash
# Nome: gerarCertificadoEcpfSefaz.sh  
# Sintaxe: gerarCertificadoEcpfSefaz.sh  <NOme do arquivo da solicitação>
# Exemplo: gerarCertificadoEcpfSefaz.sh  /work/ca/solicitacoes/11806650746-cert.req

arquivo="$1"
if [[ $(obterTipoCertificado.sh $arquivo) != "ECPF" ]]; then
  echo "O Tipo do certificado solicitado é inválido. Tipos válidos: ECPF / ECNPJ / SERVER-WEB / CA"
  exit 1
fi

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
ecpf_inss=""

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
		  ecpf_cpf="$valor"
    elif [[ "$chaveUpperCase" = "EMAIL" ]]; then
		  ecpf_email=$(echo "$valor" | tr '[:upper:]' '[:lower:]')
		elif [[ "$chaveUpperCase" = "DT_NASCIMENTO" ]]; then
		  ecpf_data_nascimento="$valor"
		elif [[ "$chaveUpperCase" = "RG" ]]; then
		  ecpf_rg="$valor"
		elif [[ "$chaveUpperCase" = "ORGAO_RG" ]]; then
			ecpf_orgao_rg=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
		elif [[ "$chaveUpperCase" = "UF_RG" ]]; then
    	ecpf_uf_rg=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
		elif [[ "$chaveUpperCase" = "NIS" ]]; then
    	ecpf_nis=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
		elif [[ "$chaveUpperCase" = "INSS" ]]; then
    	ecpf_inss=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
		elif [[ "$chaveUpperCase" = "TIPO" ]]; then
			tipo=$(echo "$valor" | tr '[:lower:]' '[:upper:]')
		fi
	fi
done < "$arq_request"

validarDadosECPF.sh "$ecpf_municipio" \
                         "$ecpf_nome" \
                         "$ecpf_cpf" \
                         "$ecpf_email" \
                         "$ecpf_data_nascimento" \
                         "$ecpf_rg" \
                         "$ecpf_orgao_rg" \
                         "$ecpf_uf_rg" \
                         "$ecpf_nis" \
                         "$ecpf_inss"
codRet=$?
if [ $codRet -gt 0 ]; then
  gravarLog.sh "Erro na validação dos dados do formulário de solicitação ." "ERROR" "" 
  exit $codRet
fi                          

atualizarConfiguracaoECPF.sh "$ecpf_municipio" \
                         "$ecpf_nome" \
                         "$ecpf_cpf" \
                         "$ecpf_email" \
                         "$ecpf_data_nascimento" \
                         "$ecpf_rg" \
                         "$ecpf_orgao_rg" \
                         "$ecpf_uf_rg" \
                         "$ecpf_nis" \
                         "$ecpf_inss" \
                         "$arq_configuracao" 
codRet=$?
if [ $codRet -gt 0 ]; then
  gravarLog.sh "Erro na construção do arquivo de configuração $arq_configuracao ." "ERROR" "" 
  #  echo "Erro na construção do arquivo de configuração $arq_configuracao ." 
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

