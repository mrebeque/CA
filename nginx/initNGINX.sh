#!/bin/bash
#
# Ler o arquivo e substituir as tags 
sed -e "s|{{DIR_EMITIDOS}}|$DIR_EMITIDOS|g" \
    -e "s|{{DIR_CA_ATIVA}}|$DIR_CA_ATIVA|g" \
    -e "s|{{DIR_TEMPLATES}}|$DIR_TEMPLATES|g" \
    "$ARQ_NGINX_CONF" > "$WORKNGINX"/temp.txt && \
     mv "$WORKNGINX"/temp.txt "$ARQ_NGINX_CONF"
chown www-data: "$ARQ_NGINX_CONF"
chmod 664 "$ARQ_NGINX_CONF" 

sed -e "s|{{DIR_SOLICITACOES}}|$DIR_SOLICITACOES|g" \
    -e "s|{{URL_CERTIFICADO}}|$URL_CERTIFICADO|g" \
       "$ARQ_NGINX_UPLOAD" > "$WORKNGINX"/temp.txt && \
     mv "$WORKNGINX"/temp.txt "$ARQ_NGINX_UPLOAD"
chown www-data: "$ARQ_NGINX_UPLOAD"
chmod 775 "$ARQ_NGINX_UPLOAD"


/etc/init.d/php8.3-fpm start
/etc/init.d/php8.3-fpm status

echo "Iniciando o NGINX"
# nginx -g "daemon off;"
/etc/init.d/nginx start
/etc/init.d/nginx status

