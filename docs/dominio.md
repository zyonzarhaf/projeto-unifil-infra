# Modelo de Domínio

## Entidades

| Entidade | Descrição |
|----------|-----------|
| **Organizacao** | Tenant principal do sistema (empresa/instituição) |
| **Usuario** | Usuários que acessam o sistema |
| **Projeto** | Projetos gerenciados dentro de uma organização |
| **Metodologia** | Templates de metodologia de gestão (ex: Scrum, Kanban) |
| **Etapa** | Fases que compõem uma metodologia |
| **Tarefa** | Unidades de trabalho dentro de projetos |
| **Status** | Estados possíveis para projetos e tarefas |
| **Papel** | Funções que usuários podem exercer em projetos |
| **Comentario** | Comentários em tarefas (com suporte a respostas) |

---

## Diagrama

```
┌─────────────┐                              ┌───────────┐
│ Organizacao │                              │  Usuario  │
└──────┬──────┘                              └─────┬─────┘
       │                                           │
       │ 1:N                           ┌───────────┼───────────┬─────────────┐
       ▼                               │           │           │             │
┌────────────────────────┐             │      N:1  │      N:1  │        N:1  │
│ organizacoes_usuarios  │─────────────┘           │           │             │
└────────────────────────┘                         │           │             │
                                                   │           │             │
┌──────────────┐     ┌───────────┐                 │           │             │
│ Metodologia  │     │  Status   │                 │           │             │
└──────┬───────┘     └─────┬─────┘                 │           │             │
       │ 1:N           1:N │                       │           │             │
       │                   │                       │           │             │
       │     ┌─────────────┘                       │           │             │
       │     │                                     │           │             │
       ▼     ▼                                     │           │             │
┌─────────────────┐                                │           │             │
│     Projeto     │◀───────────────────────────┐   │           │             │
└───────┬─────────┘                            │   │           │             │
        │                                  N:1 │   │           │             │
        ├─────────────────┬────────────────────┼───┘           │             │
        │ 1:N             │ 1:N            1:N │                │             │
        │                 │                    │                │             │
        ▼                 ▼                    │                │             │
┌───────────┐     ┌────────────────────────┐   │                │             │
│   Etapa   │     │   projetos_usuarios    │   │                │             │
└─────┬─────┘     └────────────────────────┘   │                │             │
      │ 1:N                                    │                │             │
      │           ┌───────────┐                │                │             │
      │           │  Status   │           ┌────┴────┐           │             │
      │           └─────┬─────┘           │  Papel  │           │             │
      │             1:N │                 └─────────┘           │             │
      ▼                 ▼                                       │             │
┌─────────────────────────┐                                     │             │
│         Tarefa          │─────────────────────────────────────┘             │
└───────────┬─────────────┘ (responsavel)                                     │
            │ 1:N                                                             │
            ▼                                                                 │
┌─────────────────────────┐                                                   │
│       Comentario        │───────────────────────────────────────────────────┘
└───────────┬─────────────┘ (autor)
            │
            └────▶ Comentario (parent - self N:1)
```

### Entidades Associativas

| Tabela | Relacionamento | Cardinalidade |
|--------|----------------|---------------|
| `organizacoes_usuarios` | Organizacao ↔ Usuario | N:M |
| `projetos_usuarios` | Projeto ↔ Usuario | N:M |

---

## Multi-tenancy

Todas as entidades (exceto Usuario e Organizacao) estendem `OrganizacaoModel`, que aplica automaticamente um filtro global (`OrganizacaoScope`) baseado na organização do contexto atual. Isso garante isolamento de dados entre organizações.
