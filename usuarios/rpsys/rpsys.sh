
====================================================
#Gerar Chave Privada
#-------------------
rm -f rpsys.key.old

openssl genrsa -aes256 \
               -out rpsys.key.old \
               -passout pass:8zcWmA6N 2048

# Remover a senha 
#------------------
rm -f rpsys.key
openssl rsa -in rpsys.key.old \
            -out rpsys.key \
            -passin pass:8zcWmA6N 
            


# Gerar a requisição do certificado
#---------------------------------
rm -f rpsys.csr 
openssl req -new -sha256 \
            -nodes -key rpsys.key \
            -out rpsys.csr  \
            -config rpsys.conf

# Gerar / Assinar o certificado  para cpf
#----------------------------------------
rm -f rpsys.crt 
openssl x509 -req  -copy_extensions copyall \
             -days 365 \
             -in rpsys.csr \
             -CA /work/ca/sefazrj/dist/sefazrj-ca.crt \
             -CAkey /work/ca/sefazrj/dist/sefazrj-ca.key  \
             -out rpsys.crt \
             -extfile rpsys.conf \
             -extensions req_ext

# Validar assinatura do certificado
#---------------------------------
openssl verify -CAfile /work/ca/sefazrj/dist/sefazrj-ca.crt rpsys.crt .crt
openssl x509 -in rpsys.crt -text -noout
openssl x509 -noout -modulus -in rpsys.crt | openssl md5
openssl rsa -noout -modulus -in rpsys.key | openssl md5
rm -f rpsys.p12 
openssl pkcs12 -export -out rpsys.p12  -inkey rpsys.key  -in rpsys.crt -password pass:123456


