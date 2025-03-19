
====================================================
#Gerar Chave Privada
#-------------------
rm -f rebeque.key.old
openssl genrsa -aes256 \
               -out rebeque.key.old \
               -passout pass:8zcWmA6N 2048

# Remover a senha 
#------------------
rm -f rebeque.key
openssl rsa -in rebeque.key.old \
            -out rebeque.key \
            -passin pass:8zcWmA6N 

# Gerar a requisição do certificado
#---------------------------------
rm -f rebeque.csr 
openssl req -new -sha256 \
            -nodes -key rebeque.key \
            -out rebeque.csr  \
            -config rebeque.conf
openssl req -in rebeque.csr -text -noout
# Gerar / Assinar o certificado  para cpf
#----------------------------------------
rm -f rebeque.crt 
openssl x509 -req  -copy_extensions copyall \
             -in rebeque.csr \
             -CA /work/ca/sefazrj/dist/sefazrj-ca.crt \
             -CAkey /work/ca/sefazrj/dist/sefazrj-ca.key \
             -out rebeque.crt \
             -extfile rebeque.conf \
             -extensions req_ext \
             -days 365
                   
# Validar assinatura do certificado
#---------------------------------
openssl verify -CAfile /work/ca/sefazrj/dist/sefazrj-ca.crt rebeque.crt
openssl x509 -in rebeque.crt -text -noout
openssl x509 -noout -modulus -in rebeque.crt | openssl md5
openssl rsa -noout -modulus -in rebeque.key | openssl md5
openssl pkcs12 -export -out rebeque.p12  -inkey rebeque.key  -in rebeque.crt 


