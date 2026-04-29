#!/bin/bash
set -e

# Verifica se as variáveis de ambiente estão definidas
if [ -z "$SUPABASE_URL" ]; then
  echo "ERRO: variável de ambiente SUPABASE_URL não definida."
  exit 1
fi

if [ -z "$SUPABASE_ANON_KEY" ]; then
  echo "ERRO: variável de ambiente SUPABASE_ANON_KEY não definida."
  exit 1
fi

# Substitui os placeholders no index.html pelos valores reais
sed -i "s|__SUPABASE_URL__|$SUPABASE_URL|g" index.html
sed -i "s|__SUPABASE_ANON_KEY__|$SUPABASE_ANON_KEY|g" index.html

echo "Build concluído — credenciais injetadas com sucesso."
