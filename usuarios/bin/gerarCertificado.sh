#!/bin/bash
# Autor: Marcelo Rebeque
# Data de criação: 07/03/2025
# Data de atualização: 07/03/2025
# Versão: 0.01  
source /work/ca/resources/env.sh
source /work/ca/resources/libs.sh

dir_certficado=${1}
nome_certificado=${2}
arquivo_conf=${3}

nome_base="$dir_certficado"/"$nome_certificado"

arquivo_key="$nome_base".key
arquivo_csr="$nome_base".csr
arquivo_crt="$nome_base".crt
arquivo_p12="$nome_base".p12
arquivo_log="$nome_base".log

echo "Inicio da criação do certificado: $nome_certificado " > "$arquivo_log"
#====================================================
# Gerar Chave Privada
#-------------------

rm -f -v "$arquivo_key".old 
openssl genrsa -"$cripto_key" \
               -out "$arquivo_key".old \
               -passout pass:"$senha_key" "$tamanho_key"

# Remover a senha 
#------------------
rm -v -f "$arquivo_key" >>  "$arquivo_log"
openssl rsa -in "$arquivo_key".old \
            -out "$arquivo_key" \
            -passin pass:$senha_key 
            
# Gerar a requisição do certificado
#---------------------------------
rm -f "$arquivo_csr" 
openssl req -new -"$algoritmo_ass" \
            -nodes -key "$arquivo_key" \
            -out "$arquivo_csr"  \
            -config "$arquivo_conf"

# Criar um certificado auto assinado para CA
#----------------------------------------
rm -f "$arquivo_crt" 
openssl x509 -req  -copy_extensions copyall \
             -in "$arquivo_csr" \
             -CA "$ca_certificado" \
             -CAkey "$ca_key" \
             -out "$arquivo_crt" \
             -extfile "$arquivo_conf" \
             -extensions req_ext \
             -days "$qtde_dias_ecpf" >> "$arquivo_log"
                   
# Validar assinatura do certificado
#---------------------------------
openssl verify -CAfile /work/ca/sefazrj/dist/sefazrj-ca.crt "$arquivo_crt" >>  "$arquivo_log"
openssl x509 -in "$arquivo_crt" -text -noout >>  "$arquivo_log" 
openssl x509 -noout -modulus -in "$arquivo_crt" | openssl md5 >>  "$arquivo_log"
openssl rsa  -noout -modulus -in "$arquivo_key" | openssl md5 >>  "$arquivo_log"
openssl pkcs12 -export -out "$arquivo_p12"  -inkey "$arquivo_key" -in "$arquivo_crt" -password pass:"$senha_p12" >>  "$arquivo_log"

echo "Término da criação do certificado: $nome_certificado " >> "$arquivo_log"
echo  "Consulte o arquivo de log $arquivo_log"


