FROM localhost/ubuntu-ca:1.0
SHELL ["/bin/bash", "-c"]
USER root

WORKDIR /

ENV WORKCA=/opt/ca
ENV WORKNGINX=/etc/nginx
ENV DOC_ROOT=/var/www
ENV TZ=America/Sao_Paulo

RUN ln -sf /bin/bash /bin/sh && \
    usermod -s /bin/bash www-data && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    mkdir -p  {$WORKCA/bin,$WORKCA/resources,$WORKCA/templates_csr,$DOC_ROOT/html} && \
    chmod 775 {$WORKCA/bin,$WORKCA/resources,$WORKCA/templates_csr,$DOC_ROOT/html} 

COPY --chmod=755 ./init.sh  / 
COPY --chown=www-data:www-data --chmod=755 ./CA/startCA.sh $WORKCA/
COPY --chown=www-data:www-data --chmod=755 ./CA/confCA.sh  $WORKCA/
COPY --chown=www-data:www-data --chmod=755 ./CA/initCA.sh  $WORKCA/
COPY --chown=www-data:www-data --chmod=755 ./CA/bin/       $WORKCA/bin
COPY --chown=www-data:www-data --chmod=664 ./CA/resources/ $WORKCA/resources
COPY --chown=www-data:www-data --chmod=664 ./CA/templates_csr/ $WORKCA/templates_csr
RUN chown -R www-data: {$WORKCA,$DOC_ROOT} 

## Configuração do NGINX
######
COPY --chown=www-data:www-data --chmod=775  ./nginx/initNGINX.sh  $WORKNGINX/
COPY --chown=www-data:www-data --chmod=664  ./nginx/conf/default  $WORKNGINX/sites-available/default
COPY --chown=www-data:www-data --chmod=775  ./nginx/html/         $DOC_ROOT/html

### Expose the HTTP/HTTPS port
EXPOSE 80 443

ENTRYPOINT ["sleep", "infinity"]   
#llENTRYPOINT ["/bin/bash", "-c", "/init.sh"]
