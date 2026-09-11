# Infraestrutura

Configuração de infraestrutura para ambiente de desenvolvimento local e produção.

## Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) (v20.10+)
- [Docker Compose](https://docs.docker.com/compose/install/) (v2.0+)
- Git

## Estrutura de Repositórios

O projeto é composto por três repositórios que devem estar no mesmo diretório:

```
Exemplo/
├── projeto-unifil-infra/       # Este repositório (infraestrutura)
├── projeto-unifil-general-api/ # Backend Laravel
└── projeto-unifil-fe/          # Frontend React
```

## Setup do Ambiente de Desenvolvimento

### 1. Clonar os repositórios

```bash
git clone https://github.com/zyonzarhaf/projeto-unifil-infra.git
git clone https://github.com/zyonzarhaf/projeto-unifil-general-api.git
git clone https://github.com/zyonzarhaf/projeto-unifil-fe.git
```

### 2. Configurar variáveis de ambiente

```bash
cd projeto-unifil-infra
cp .env.example .env
```

Gere as chaves necessárias:

```bash
# Gerar APP_KEY (requer PHP instalado localmente ou use o container)
docker run --rm -v $(pwd)/../projeto-unifil-general-api:/app -w /app composer:2 \
  sh -c "composer install -q && php artisan key:generate --show"

# Gerar JWT_SECRET
docker run --rm -v $(pwd)/../projeto-unifil-general-api:/app -w /app composer:2 \
  sh -c "php artisan jwt:secret --show"
```

Edite o arquivo `.env` e substitua os valores de `APP_KEY` e `JWT_SECRET` pelos gerados.

### 3. Subir os containers

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build
```

### 4. Executar migrations e seeders

Em outro terminal:

```bash
# Aguardar o banco estar pronto
docker compose exec api php artisan migrate --force

# Popular dados iniciais (roles, permissions, usuário admin)
docker compose exec api php artisan db:seed
```

### 5. Acessar a aplicação

- **Frontend**: http://localhost:8080
- **API**: http://localhost:8080/api

## Comandos Úteis

### Logs

```bash
# Todos os serviços
docker compose logs -f

# Serviço específico
docker compose logs -f api
docker compose logs -f frontend
docker compose logs -f caddy
```

### Executar comandos no backend

```bash
# Artisan
docker compose exec api php artisan <comando>

# Composer
docker compose exec api composer <comando>

# Testes
docker compose exec api php artisan test
```

### Executar comandos no frontend

```bash
docker compose exec frontend npm run <comando>
```

### Reiniciar serviços

```bash
docker compose restart api
docker compose restart frontend
```

### Parar e remover containers

```bash
# Parar
docker compose down

# Parar e remover volumes (apaga dados do banco)
docker compose down -v
```

### Rebuild de um serviço específico

```bash
docker compose up --build api
docker compose up --build frontend
```

## Arquitetura

```
┌─────────────────────────────────────────────────────────────┐
│                      localhost:8080                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     Caddy (Reverse Proxy)                   │
│                                                             │
│   /api/*  ──────────────────────▶  api:8000 (Laravel)       │
│   /*      ──────────────────────▶  frontend:5173 (Vite)     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   PostgreSQL (db:5432)                      │
│                                                             │
│   Porta externa: localhost:5433                             │
└─────────────────────────────────────────────────────────────┘
```

## Serviços

| Serviço | Descrição | Porta Interna | Porta Externa |
|---------|-----------|---------------|---------------|
| caddy | Reverse proxy | 80 | 8080 |
| api | Backend Laravel (PHP 8.4) | 8000 | - |
| frontend | Frontend React (Vite) | 5173 | - |
| db | PostgreSQL 16 | 5432 | 5433 |

## Conectar ao Banco de Dados

```bash
# Via psql
psql -h localhost -p 5433 -U laravel -d projeto_unifil

# Via Docker
docker compose exec db psql -U laravel -d projeto_unifil
```

## Troubleshooting

### Erro de permissão no frontend (node_modules)

```bash
docker compose down
docker volume rm projeto-unifil-infra_node_modules 2>/dev/null || true
docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build frontend
```

### Banco de dados não conecta

Verifique se o container do banco está rodando:

```bash
docker compose ps db
docker compose logs db
```

### Migrations falham

Aguarde o banco estar completamente inicializado:

```bash
docker compose exec db pg_isready -U laravel
# Quando retornar "accepting connections", execute as migrations
```

### Limpar tudo e recomeçar

```bash
docker compose down -v
docker system prune -f
docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build
```

## Documentação Adicional

- [Arquitetura do Sistema](docs/arquitetura.md)
- [Autenticação](docs/autenticacao.md)
- [Modelo de Domínio](docs/dominio.md)

## Produção

O deploy em produção é automatizado via GitHub Actions. Consulte os workflows em `.github/workflows/` para detalhes.
