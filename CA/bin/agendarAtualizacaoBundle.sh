#!/bin/bash

. $WORKCA/resources/resource.env

arq_log="$DIR_LOG"/agendarAtualizacaoBundle.log
data_hora_atual=$(date +"%d/%m/%Y %H:%M:%S")

if [ ! -f  "$arq_log" ]; then
   echo "$data_hora_atual - Info: Log iniciado! " > "$arq_log"
fi


if [ ! -e "$arq_log" ]; then 
   echo "$data_hora_atual - Info: Log iniciado! " > $arq_log
fi

while true; do
    # Obtém a hora atual (formato 24H:MM)
    hora_atual=$(date +"%H:%M")
    data_hora_atual=$(date +"%d/%m/%Y %H:%M:%S")

    # Verifica se é 06:00
    if [ "$hora_atual" = "06:00" ]; then
        atualizarBundle.sh
        echo "$data_hora_atual - Info: Bundo atulizado com informações do ICP-Brasil!" >> $arq_log

        # Evita repetir a mensagem múltiplas vezes no mesmo minuto
        sleep 60  # Espera 1 minuto antes de verificar novamente
    fi

    sleep 30  # Verifica a cada 30 segundos (ajuste conforme necessário)
done
