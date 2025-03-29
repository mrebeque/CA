#!/bin/bash

arqLog="$DIR_LOG"/geradorCert.log
if [ -e "$arqLog" ]; then
    echo "Arquivo de log $arqLog : Iniciado!"
else
    echo $(date +"%d/%m/%Y %H:%M") "INFO: Log iniciado" > "$arqLog"  
fi

while true; do
    echo "Listando arquivos .req na $DIR_SOLICITACOES"

    find "$DIR_SOLICITACOES" -type f -name "*.req" | while read -r arquivo; do 
        dataHora=$(date +"%d/%m/%Y %H:%M") 
        tipoCertificado=$(obterTipoCertificado.sh $arquivo)
        
        if [[ "$tipoCertificado" = "ECPF" ]]; then 
        	gerarCertificadoEcpfSefaz.sh $arquivo
        	
        elif [[ "$tipoCertificado" = "ECNPJ" ]]; then 
          gerarCertificadoEcnpjSefaz.sh $arquivo
					         
        elif [[ "$tipoCertificado" = "SERVER-WEB" ]]; then 
        	gerarCertificadoServerWeb.sh $arquivo
        	
        elif [[ "$tipoCertificado" = "CA" ]]; then 
        	gerarCA.sh $arquivo
        	  
        else
          echo "$dataHora - ERROR: O tipo de certificado $tipoCertificado solicitado pelo arquivo $arquivo é inválido!" >> "$arqLog" 
        fi
        mv "$arquivo" "$DIR_PROCESSADAS"/
        echo "$dataHora - INFO: A solicitação $arquivo processada e movida para $DIR_PROCESSADAS ." >> "$arqLog" 
                
    done
    echo "Aguardando 5s para novo processamento!"
    sleep 5
done

