# Autenticação e Controle de Acesso

## Autenticação via JWT

O sistema utiliza **JSON Web Tokens (JWT)** para autenticação stateless.

### Fluxo de Login

```
1. POST /api/login (email + password)
2. Valida credenciais
3. Gera JWT com claims do usuário
4. Token dividido em dois cookies:
   ├── token_payload (cookie normal, JS pode ler)
   └── token_signature (cookie HttpOnly, protegido)
5. Frontend lê claims do token_payload (via jose)
6. Middleware JwtFromCookie reconstrói o Bearer token nos requests
```

### Claims do JWT

| Claim | Descrição |
|-------|-----------|
| `sub` | ID do usuário |
| `usuario_nome` | Nome do usuário |
| `usuario_sobrenome` | Sobrenome do usuário |
| `usuario_usuario` | Username |
| `usuario_email` | Email |
| `usuario_papel` | Role atual (no contexto da organização) |
| `organizacao_id` | ID da organização selecionada |
| `organizacao_nome` | Nome da organização |
| `projeto_id` | ID do projeto selecionado |
| `projeto_titulo` | Título do projeto |
| `permissions` | Permissões (comprimidas com DEFLATE) |
| `csrf_token` | Token CSRF embutido |

### Compressão de Permissões

O claim `permissions` é comprimido com DEFLATE e codificado em base64url para reduzir o tamanho do token. O frontend descomprime usando `pako.inflateRaw`.

### Proteção CSRF

O JWT inclui um `csrf_token`. O frontend extrai esse token do cookie `token_payload` e envia no header `X-CSRF-TOKEN`. Requests mutáveis (POST, PUT, DELETE) são validados pelo middleware `VerifyJwtCsrfToken`.

---

## Controle de Acesso (RBAC)

Implementado com **Spatie Laravel Permission** com suporte a Teams.

### Roles

| Role | Escopo | Permissões |
|------|--------|------------|
| `super-admin` | Global | Acesso total, cross-organização |
| `admin` | Organização | CRUD completo no contexto |
| `membro` | Organização | Operações básicas |

### Permissões

Usam padrão wildcard: `usuarios.*`, `projetos.*`, etc.

Permissão especial: `usuarios.access-cross-organizacao` permite visualizar dados de outras organizações.

---

## Multi-tenancy por Organização

### Contexto de Organização

O JWT carrega o `organizacao_id` do contexto atual.

### Troca de Contexto

```
POST /api/organizacao-context
├── Valida acesso à organização
├── Invalida token atual
└── Gera novo JWT com novo contexto

POST /api/projeto-context
├── Valida acesso ao projeto
├── Invalida token atual
└── Gera novo JWT com novo contexto
```

### Filtragem Automática

`OrganizacaoScope` adiciona `WHERE organizacao_id = X` em todas as queries de models que estendem `OrganizacaoModel`.

---

## Níveis de Acesso por Rota

| Nível | Middlewares | Exemplos |
|-------|-------------|----------|
| Público | - | `/login`, `/forgot-password` |
| Autenticado | `auth:api` | `/logout`, `/perfil` |
| + Organização | `require.organizacao` | `/projetos`, `/metodologias` |
| + Projeto | `require.projeto` | `/tarefas`, `/comentarios` |

---

## Middlewares

| Middleware | Função |
|------------|--------|
| `JwtFromCookie` | Reconstrói Bearer token a partir dos cookies |
| `VerifyJwtCsrfToken` | Valida CSRF token em requests mutáveis |
| `ResolveOrganizacaoContext` | Lê org do JWT e registra no container |
| `RequireOrganizacaoContext` | Bloqueia acesso sem org selecionada |
| `ResolveProjetoContext` | Lê projeto do JWT e registra no container |
| `RequireProjetoContext` | Bloqueia acesso sem projeto selecionado |
