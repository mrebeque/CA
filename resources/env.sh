# env.sh
#!/bin/bash

# Parametros para a construção do arquivo de requisição de assinatura
# ===================================================================
export resourceDIR=/work/ca/resources
export CAdir=/work/ca/autoridades
export usuarioDir=/work/ca/usuarios
export usuarioDir=/work/ca/
export bundleDir=

export dirSolicitacoes=/work/ca/solicitacoes

export dirTemplates=/work/ca/templates
export url_clr=http://icp-brasil.certisign.com.br/repositorio/lcr/ACCACBRFBG2/LatestCRL.crl

export template_ecpf_sefaz="$dirTemplates"/"e-cpf-sefaz.conf"
export template_ecpf_padrao="$dirTemplates"/"e-cpf.conf"
export template_ecnpj_sefaz="$dirTemplates"/"e-cnpj-sefaz.conf"
export template_ecnpj_padrao="$dirTemplates"/"e-cnpj.conf"
export template_web_server="$dirTemplates"/"web-server.conf"
export template_ca="$dirTemplates"/"ca.conf"

# Parametros de configuração do certificado
# ===========================================
export cripto_key=aes256
export algoritmo_ass=sha256
export tamanho_key=2048
export senha_key=8zcWmA6N
export senha_p12=123456
export ca_certificado=/work/ca/ca-sefazrj/sefazrj-ca.crt
export ca_key=/work/ca/ca-sefazrj/sefazrj-ca.key
export qtde_dias_ecpf=365
export qtde_dias_ecnpj=365
export qtde_dias_server=3650
export qtde_dias_ca=3650

