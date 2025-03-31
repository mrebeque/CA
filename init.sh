#!/bin/bash

. $WORKCA/resources/resource.env
$WORKNGINX/initNGINX.sh  

su - www-data -c "$WORKCA/startCA.sh $WORKCA/resources/resource.env" 
echo "APP CA-MANAGER Iniciada !"

