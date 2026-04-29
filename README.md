Sistema Pessoal de Gestão de Atividades (SPGA)

Aplicação web (Single-Page Application) para organização de atividades semanais, com autenticação, persistência em banco de dados e gestão de anexos.

Desenvolvida em HTML, CSS e JavaScript puro (Vanilla JS), com integração ao Supabase como backend e deploy via Vercel.

Visão geral

O sistema foi construído para uso pessoal e organização de demandas, com foco em:

estruturação de atividades por períodos (seções)
acompanhamento de status
registro de contexto (descrições e anotações)
checklists internos
anexos vinculados a cada atividade

Os dados são isolados por usuário, com controle de acesso baseado em autenticação e políticas aplicadas diretamente no banco.

Arquitetura

A aplicação segue modelo client-side, com backend gerenciado:

Front-end: SPA em JavaScript puro
Autenticação: Supabase Auth (JWT)
Banco de dados: PostgreSQL com Row Level Security (RLS)
Armazenamento: Supabase Storage (bucket privado)
Deploy: Vercel (injeção de variáveis em build)

A autorização não é implementada no front-end. O controle de acesso é delegado ao banco por meio de políticas RLS.

Segurança e controle de acesso

O sistema utiliza isolamento de dados por usuário com base em auth.uid().

Principais mecanismos:

RLS nas tabelas sections e items
validação de propriedade (auth.uid() = user_id)
garantia de que itens só podem ser vinculados a seções do próprio usuário
Storage privado (sem uso de URLs públicas)
acesso a arquivos via URLs assinadas com expiração (1h)

Os arquivos são armazenados com estrutura:

{user_id}/{item_id}/{timestamp}_{nome_arquivo}

Essa estrutura é validada pelas políticas do Storage:

auth.uid()::text = (storage.foldername(name))[1]
Gestão de anexos
upload com validação de tipo e tamanho (máx. 20MB)
arquivos armazenados em bucket privado
geração de URLs temporárias apenas no momento de visualização
URLs assinadas não são persistidas no banco
remoção explícita de arquivos no Storage ao excluir atividades ou seções
Configuração de credenciais

O projeto utiliza placeholders no código:

const SUPABASE_URL = '__SUPABASE_URL__';
const SUPABASE_ANON_KEY = '__SUPABASE_ANON_KEY__';

As credenciais são injetadas no momento do deploy via variáveis de ambiente no Vercel.

Isso evita exposição direta no repositório público, embora a chave pública continue acessível no bundle final (comportamento esperado em aplicações client-side).

Deploy

O deploy é realizado via Vercel com script de build:
substituição dos placeholders no index.html
publicação como site estático
atualização automática a partir do GitHub
Controle de acesso

O sistema não permite criação pública de contas.

O acesso é restrito a usuários previamente autorizados via painel do Supabase.

Limitações e trade-offs

A aplicação segue arquitetura totalmente client-side, utilizando Supabase como backend gerenciado. Não há camada intermediária de API para controle adicional de requisições;
O controle de acesso depende da correta configuração de políticas de Row Level Security (RLS) e regras de Storage no Supabase;
Não há implementação de mecanismos adicionais de controle de uso (ex.: rate limiting ou proteção contra abuso), sendo este um aspecto delegado ao ambiente de backend gerenciado;
A chave pública (anon key) é utilizada no client conforme padrão de aplicações baseadas em BaaS, com segurança garantida pelas políticas de acesso no backend.

Objetivo do projeto

Este projeto foi desenvolvido como:

ferramenta pessoal de organização
exercício prático de integração com Supabase
base para aplicações com controle de acesso por usuário e armazenamento de dados

Licença
Projeto de uso pessoal
