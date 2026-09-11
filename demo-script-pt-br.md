# Projeto UniFil — Roteiro de Demonstração (10 min)

## Preparação Antes da Apresentação
- App rodando em `http://localhost:8080`
- Banco de dados recém-populado (`migrate:fresh
  --seed`)
- Começar no modo claro
- Navegador aberto na página de login

---

## 1. Login e Seleção de Tenant (1 min)

**[Página de Login]**
> "Este é um sistema de gerenciamento de projetos
> multi-tenant construído com React, Mantine e
> Laravel. Vamos fazer login."

- Fazer login com as credenciais de teste (ver `.env.example`)

**[Seleção de Tenant]**
> "Após o login, o usuário seleciona em qual
> organização deseja trabalhar. Cada tenant possui
> dados isolados — projetos, tarefas, usuários, tudo é
> separado por tenant."

- Selecionar "Tenant Padrão" → Continuar

---

## 2. Dashboard (1 min)

**[Dashboard]**
> "O dashboard apresenta uma visão geral: 6 projetos,
> 35 tarefas divididas por status, 17 membros da
> equipe e 92 comentários. À direita, a atividade
> recente mostra as últimas tarefas com seu status e
> projeto."

- Destacar os cards de estatísticas, a divisão por
  status e o feed de atividades
- Clicar em um link de tarefa para mostrar que navega
  até o detalhe da tarefa (depois voltar)

---

## 3. Projetos — CRUD Completo (2 min)

**[Lista de Projetos]**
> "Aqui está a tabela de projetos. Todas as tabelas do
> sistema suportam filtragem, ordenação, paginação,
> visibilidade de colunas e alternância de densidade."

- Demonstrar: digitar no filtro de título → mostrar
  que a filtragem funciona
- Clicar em um cabeçalho de ordenação → mostrar a
  ordenação
- Clicar em visibilidade de colunas → alternar uma
  coluna ligada/desligada

**[Criar Projeto]**
> "Vamos criar um projeto."

- Clicar em "Cadastrar" → preencher: título "Projeto
  Demo", selecionar Scrum, selecionar Pendente,
  adicionar data de início → Enviar
- Mostrar que redireciona de volta para a lista e o
  novo projeto aparece

**[Detalhe do Projeto]**
> "Ao abrir um projeto, são exibidos seus detalhes,
> membros da equipe e tarefas agrupadas por etapas da
> metodologia."

- Clicar em "Sistema de Gestão Acadêmica"
- Destacar: informações do cabeçalho, lista de membros
  (adicionar/remover membros), tarefas agrupadas por
  etapa
- Mostrar o botão "Nova Tarefa" → navega para a
  criação de tarefa com o projeto pré-selecionado
- Mostrar os ícones de visualizar/editar em cada
  tarefa

**[Editar Projeto]**
- Clicar em "Editar" → mostrar que o formulário é
  pré-preenchido → alterar algo → Salvar → redireciona
  de volta

---

## 4. Tarefas — CRUD + Comentários (2,5 min)

**[Lista de Tarefas]**
> "As tarefas possuem sua própria tabela com filtros
> de projeto e status."

- Mostrar a tabela com as colunas de projeto e status
  preenchidas

**[Detalhe da Tarefa]**
> "Vamos abrir uma tarefa para ver o sistema de
> comentários."

- Clicar em qualquer tarefa (ex.: "Levantar requisitos
  com coordenadores")
- Destacar: informações da tarefa, badge de status,
  badge de etapa, nome do responsável, datas

**[Comentários em Árvore]**
> "Os comentários suportam respostas em árvore, como
> no Reddit. Cada resposta se conecta ao comentário
> pai com linhas de árvore."

- Mostrar os comentários em árvore existentes
- Postar um novo comentário → mostrar que aparece
  instantaneamente
- Clicar em "Responder" em um comentário → postar uma
  resposta → mostrar que fica aninhada sob o pai
- Clicar em "Editar" no seu próprio comentário →
  editar inline → salvar
- Clicar em "Remover" → mostrar diálogo de confirmação
  → confirmar → mostrar "Este comentário foi removido"
  mas as respostas permanecem

> "Apenas o autor do comentário pode editar ou excluir
> seus próprios comentários. Comentários excluídos são
> soft-deleted — as respostas são preservadas."

---

## 5. Metodologias + Etapas (1,5 min)

**[Lista de Metodologias]**
> "As metodologias definem as etapas do fluxo de
> trabalho dos projetos."

- Abrir a página de detalhe do "Scrum"
- Mostrar a lista de etapas com setas de reordenação

**[Reordenar Etapas]**
> "As etapas podem ser reordenadas com setas para
> cima/baixo. As alterações são locais até clicar em
> Salvar."

- Mover uma etapa para cima → mostrar que os botões
  "Salvar Ordem" e "Resetar" aparecem
- Clicar em "Resetar" → mostrar que reverte
- Mover novamente → clicar em "Salvar Ordem" → mostrar
  que persiste

**[CRUD de Etapas]**
- Mostrar a tabela independente de etapas com coluna
  de metodologia, filtragem e ordenação

---

## 6. Entidades de Configuração (1 min)

**[Status / Papéis]**
> "Status e Papéis são entidades de consulta simples
> com CRUD completo — criar, editar, excluir com
> diálogos de confirmação."

- Abrir Status → mostrar a tabela
- Clicar em excluir em um → mostrar modal de
  confirmação → Cancelar
- Abrir Papéis → clicar em editar em "Desenvolvedor" →
  mostrar que o formulário é pré-preenchido → Cancelar

---

## 7. Usuários e Perfil (1 min)

**[Lista de Usuários]**
> "Gerenciamento de usuários — 17 usuários neste
> tenant, todos com CRUD completo."

- Mostrar a tabela de usuários

**[Perfil]**
- Clicar no avatar do usuário → "Perfil"
- Mostrar a página de perfil com campos editáveis
- Mencionar que a alteração de senha é opcional

---

## 8. Arquitetura e Stack Tecnológica (1 min)

> "Visão rápida da arquitetura:"

> **Backend**: Laravel 11, PostgreSQL, autenticação
> JWT, multi-tenant com global scopes, Spatie Query
> Builder para filtragem/ordenação, soft deletes em
> comentários, classes de ordenação customizadas para
> colunas de relacionamento.

> **Frontend**: React 19, TypeScript, Vite, Mantine UI
> com tema brutalista customizado, TanStack React
> Query para estado do servidor, Zod para validação,
> arquitetura limpa com modelos de domínio, mappers,
> adapters e um container de DI.

> **Infraestrutura**: Docker Compose com proxy reverso
> Caddy, PostgreSQL e servidor de desenvolvimento com
> hot-reload.

> "Todo formulário segue o mesmo padrão: FormAdapter
> popula os valores iniciais, Zod valida, Mapper
> converte camelCase para snake_case para a API. Toda
> tabela possui filtragem, ordenação, paginação e
> controles de colunas."

---

## Encerramento

> "Este é o sistema completo — CRUD completo em todas
> as entidades, comentários em árvore, isolamento
> multi-tenant e uma arquitetura consistente em toda a
> stack. Perguntas?"

---

## Atalhos de Emergência (se o tempo estiver curto)

- Pular seção 5 (Metodologias) — economiza 1,5 min
- Pular seção 6 (Status/Papéis) — economiza 1 min
- Combinar seções 7+8 em 30 segundos
- As seções obrigatórias são: 1 (login), 2
  (dashboard), 3 (projetos), 4 (comentários)

---

## Roadmap — Funcionalidades Futuras

> "Para finalizar, gostaria de apresentar brevemente o
> que planejamos implementar nas próximas versões."

### Controle de Acesso e Permissões
- **Papéis por projeto**: cada membro poderá ter um
  papel específico dentro de cada projeto (Gerente,
  Desenvolvedor, Designer, etc.), vinculando a tabela
  `papeis` à tabela `projetos_usuarios`.
- **Sistema de permissões**: controle granular sobre
  quem pode criar, editar e excluir entidades. Por
  exemplo, apenas gerentes de projeto poderão excluir
  tarefas ou remover membros.
- **Papéis no tenant**: expandir os papéis de tenant
  (atualmente apenas "owner" e "member") para incluir
  "admin", permitindo gestão hierárquica da
  organização.

### Sistema de Notificações
- **Notificações em tempo real**: alertar usuários
  quando alguém comenta em suas tarefas, responde seus
  comentários, ou os adiciona a um projeto.
- **Central de notificações**: painel persistente com
  histórico de notificações (lidas/não lidas),
  acessível pelo cabeçalho.
- **Notificações por e-mail**: envio opcional de
  e-mails para eventos importantes (atribuição de
  tarefa, menção em comentário, prazo próximo).

### Registro de Atividades (Audit Trail)
- **Log de alterações**: registrar quem alterou o quê
  e quando — criação, edição e exclusão de qualquer
  entidade.
- **Histórico por entidade**: visualizar o histórico
  completo de alterações de um projeto, tarefa ou
  comentário.
- **Feed de atividades no dashboard**: expandir o
  dashboard com um feed detalhado de atividades
  recentes da equipe.

### Busca Global
- **Busca unificada**: campo de busca no cabeçalho que
  pesquisa simultaneamente em projetos, tarefas,
  comentários e usuários.
- **Resultados agrupados**: exibir resultados
  categorizados por tipo de entidade com links
  diretos.

### Anexos de Arquivos
- **Upload de arquivos**: permitir anexar documentos,
  imagens e outros arquivos a projetos, tarefas e
  comentários.
- **Armazenamento**: integração com S3 ou
  armazenamento local via Laravel Filesystem.
- **Pré-visualização**: visualização inline de imagens
  e PDFs.

### Gestão de Tenants
- **Criação de tenants**: permitir que usuários criem
  novas organizações.
- **Convites**: sistema de convite por e-mail para
  adicionar novos membros ao tenant.
- **Configurações do tenant**: página de configurações
  com nome, logo e preferências da organização.

### Melhorias no Dashboard
- **Gráficos**: adicionar gráficos de progresso dos
  projetos, distribuição de tarefas por membro e
  evolução temporal usando Mantine Charts (Recharts).
- **Widgets personalizáveis**: permitir que cada
  usuário configure quais cards e gráficos deseja ver
  no dashboard.
- **Tarefas atrasadas**: destaque visual para tarefas
  com prazo vencido.

### Melhorias de UX
- **Drag and drop**: reordenação de etapas e tarefas
  via arrastar e soltar.
- **Atalhos de teclado**: navegação rápida entre
  páginas e ações comuns.
- **Modo offline**: cache local para consulta de dados
  quando sem conexão.
