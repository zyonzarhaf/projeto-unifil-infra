# Arquitetura do Sistema

## Visão Geral

Sistema multi-repo containerizado com deploy automatizado na AWS.

```
┌─────────────────────────────────────────────────────────────┐
│                         Browser                             │
└─────────────────────────────┬───────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Caddy (Reverse Proxy)                    │
│                     :80 / :443 (HTTPS)                      │
└───────────────┬─────────────────────────────┬───────────────┘
                │                             │
         /api/* │                             │ /*
                ▼                             ▼
┌───────────────────────────┐   ┌───────────────────────────┐
│      API (Laravel)        │   │   Frontend (React/Vite)   │
│          :8000            │   │   (static files em prod)  │
└─────────────┬─────────────┘   └───────────────────────────┘
              │
              ▼
┌───────────────────────────┐
│   PostgreSQL 16           │
│        :5432              │
└───────────────────────────┘
```

---

## Stack Tecnológica

| Camada | Tecnologia |
|--------|------------|
| Reverse Proxy | Caddy (auto-TLS) |
| Backend | Laravel + PHP |
| Frontend | React + Vite + TypeScript |
| Banco de Dados | PostgreSQL 16 |
| Containerização | Docker + Docker Compose |
| CI/CD | GitHub Actions |
| Cloud | AWS EC2 |
| Registry | GitHub Container Registry |

---

## Repositórios

```
projeto-unifil-infra        → Orquestração e CI/CD
projeto-unifil-general-api  → Backend Laravel
projeto-unifil-fe           → Frontend React
```

---

## Containers

| Container | Imagem | Porta |
|-----------|--------|-------|
| `caddy` | `ghcr.io/zyonzarhaf/unifil-caddy` | 80, 443 |
| `api` | `ghcr.io/zyonzarhaf/unifil-api` | 8000 (interno) |
| `db` | `postgres:16-alpine` | 5432 (interno) |

---

## Pipeline de Deploy

```
Push em main (qualquer repo)
        │
        ▼
┌───────────────────┐
│   CI (ci.yml)     │
│ Build + Push GHCR │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│ Deploy (deploy.yml)│
│ AWS SSM → EC2     │
│ docker compose up │
│ php artisan migrate│
└───────────────────┘
```

---

## Ambientes

| Aspecto | Desenvolvimento | Produção |
|---------|-----------------|----------|
| Porta | 8080 | 80/443 |
| HTTPS | Não | Sim (Caddy auto-TLS) |
| Frontend | Vite dev server (HMR) | Static files |
| Imagens | Build local | GHCR |
| DB exposto | Sim (:5433) | Não |

---

## Arquivos Principais

```
projeto-unifil-infra/
├── docker-compose.yml      # Produção
├── docker-compose.dev.yml  # Desenvolvimento
├── Dockerfile              # API (prod)
├── Dockerfile.dev          # API (dev)
├── Caddyfile               # Proxy config (prod)
├── Caddyfile.dev           # Proxy config (dev)
├── caddy/
│   └── Dockerfile          # Caddy + frontend
└── .github/workflows/
    ├── ci.yml              # Build de imagens
    └── deploy.yml          # Deploy para EC2
```
