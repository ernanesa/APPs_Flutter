# 📚 Documentação — Flutter App Factory (source of truth)

Este diretório concentra **apenas** documentação “de processo” (como fazemos as coisas).  
Relatórios/snapshots gerados por scripts devem ir para `artifacts/` (ou serem regeneráveis).

## 🚀 Atalhos (use o que você precisa agora)

### Quero desenvolver (padrão único para todos os apps)
Leia: `docs/PLAYBOOK.md`

### Quero validar se um app está pronto (QA Factory)
Leia: `docs/QA.md`

### Quero publicar (Play Console + automações)
Leia: `docs/PUBLISHING.md`

### Encontrei um blocker e resolvi (evitar retrabalho)
Atualize: `docs/KNOWLEDGE_BASE.md`

## 🔧 Comandos essenciais

```bash
# Setup do workspace
dart pub global activate melos
melos bootstrap

# Quality gate rápido (lint + tests + l10n)
melos run qa

# Pipeline completo de validação (por app)
melos run validate:qa:full -- -AppName <nome_do_app>

# Publicação/status
melos run gen:publication-status
```

## 🧭 Índice

- `docs/PLAYBOOK.md` — padrões obrigatórios (i18n, tema, settings, ads, arquitetura)
- `docs/QA.md` — QA Factory (golden, device, perf, security, self-heal)
- `docs/MASTER_TEST_PLAN.md` — plano mestre de testes (device real, matriz, checklists)
- `docs/PUBLISHING.md` — publicação (assets, Play Console, automação Playwright/API)
- `docs/KNOWLEDGE_BASE.md` — aprendizados + soluções (formato padronizado)
- `docs/CODEBASE.md` — mapa cognitivo do repositório (para IA)


---

## 🔧 Desenvolvimento

### Regras de Código

1. **Use const constructors** sempre que possível
2. **ListView.builder** para listas, nunca ListView com children
3. **Riverpod** para estado, nunca setState para lógica complexa
4. **Imports de pacote**, nunca relativos entre pacotes
5. **Nunca hardcode** Ad Unit IDs

### Antes de Commit

```bash
melos run analyze        # Deve passar sem erros
melos run test:all       # Todos os testes verdes
flutter format .         # Código formatado
```

---

## 📄 Licença

Proprietário - Todos os direitos reservados.

---

## 🤝 Contribuição

1. Leia o [CODEBASE.md](CODEBASE.md)
2. Use os workflows do Antigravity
3. Siga as regras de código
4. Teste antes de commitar
