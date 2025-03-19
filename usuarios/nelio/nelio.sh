
====================================================
#Gerar Chave Privada
#-------------------
rm -f nelio.key.old
openssl genrsa -aes256 \
               -out nelio.key.old \
               -passout pass:8zcWmA6N 2048

# Remover a senha 
#------------------
rm -f nelio.key
openssl rsa -in nelio.key.old \
            -out nelio.key \
            -passin pass:8zcWmA6N 

# Gerar a requisição do certificado
#---------------------------------
rm -f nelio.csr 
openssl req -new -sha256 \
            -nodes -key nelio.key \
            -out nelio.csr  \
            -config nelio.conf
            
openssl req -in nelio.csr -text -noout
# Gerar / Assinar o certificado  para cpf
#----------------------------------------
rm -f nelio.crt 
openssl x509 -req  -copy_extensions copyall \
             -in nelio.csr \
             -CA /work/ca/sefazrj/dist/sefazrj-ca.crt \
             -CAkey /work/ca/sefazrj/dist/sefazrj-ca.key \
             -out nelio.crt \
             -extfile nelio.conf \
             -extensions req_ext \
             -days 365
                   
# Validar assinatura do certificado
#---------------------------------
openssl verify -CAfile /work/ca/sefazrj/dist/sefazrj-ca.crt nelio.crt
openssl x509 -in nelio.crt -text -noout
openssl x509 -noout -modulus -in nelio.crt | openssl md5
openssl rsa -noout -modulus -in nelio.key | openssl md5
openssl pkcs12 -export -out nelio.p12  -inkey nelio.key  -in nelio.crt 


