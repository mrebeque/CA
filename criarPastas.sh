#!/bin/bash
#
HOME=$(pwd)
mkdir -p {$WORKCA/storage/autoridades,$WORKCA/storage/bundle,$WORKCA/storage/ca-ativa,$WORKCA/storage/emitidos, \
         $WORKCA/storage/processadas,$WORKCA/storage/solicitacoes,$WORKCA/storage/templates,$WORKCA/storage/usuarios}
 
cp -p &HOME/storage/ca-ativa/*  $WORKCA/storage/ca-ativa/
cp -p &HOME/storage/templates/* $WORKCA/storage/templates/


