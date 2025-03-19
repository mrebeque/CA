# libs.sh
#!/bin/bash

obter_tipo() {
  local retorno=""
  local nomeArquivo=$1
    
	while IFS='=' read -r chave valor; do
	  # Ignora linhas vazias e comentários (que começam com #)
	  if [[ -n "$chave" && "$chave" != \#* ]]; then	  
			chaveUpperCase=$(echo "$chave" | tr '[:lower:]' '[:upper:]')
			
			if [[ "$chaveUpperCase" = "TIPO" ]]; then
			  retorno=$(echo "$valor" | tr '[:lower:]' '[:upper:]')

			fi
	  fi
	done < "$nomeArquivo"
  echo "$retorno"
}

