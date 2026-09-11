# Documentação do Sistema de Gestão de Projetos

## Conteúdo

- [Modelo de Domínio](dominio.md) — Entidades, relacionamentos e cardinalidades
- [Autenticação e Controle de Acesso](autenticacao.md) — JWT, RBAC e multi-tenancy
- [Arquitetura](arquitetura.md) — Infraestrutura, contêiners e deploy

---

## Visão Rápida

**Stack:** Laravel + React + PostgreSQL + Docker

**Arquitetura:** Multi-repo com 3 containers (Caddy, API, DB)

**Deploy:** GitHub Actions → AWS EC2 via SSM

**Autenticação:** JWT com cookies + RBAC por organização
