# **Plano de Arquitetura: Do App Simples ao SuperApp (Modular)**

Para cumprir o requisito de criar apps individuais que depois serão agregados, NÃO podemos usar uma estrutura monolítica comum (lib/main.dart cheio de tudo).

Utilizaremos uma **Arquitetura Modular Baseada em Packages**.

## **1\. Estrutura de Pastas (O Segredo)**

Mesmo para o primeiro app simples, a estrutura deve ser pensada como um monorepo.

/root\_project  
  /apps  
     /app\_individual\_01 (sa.rezende.calculadora)  
     /app\_individual\_02 (sa.rezende.todo)  
     /super\_app\_agregador (sa.rezende.superapp)  
  /packages (Módulos Reutilizáveis)  
     /core\_ui (Design System: Cores, Tipografia, Botões Padrão)  
     /core\_logic (Auth, Gerenciamento de Estado Base, Networking)  
     /feature\_ads (Lógica centralizada do AdMob \- MUITO IMPORTANTE)  
     /feature\_i18n (Traduções compartilhadas)

## **2\. Benefícios desta Estrutura**

1. **Uniformidade Visual:** Todos os apps consomem o pacote core\_ui. Se você mudar a cor primária no core\_ui, todos os apps atualizam. Isso garante a coesão visual exigida.  
2. **Lógica de Ads Centralizada:** O pacote feature\_ads controla os IDs dos blocos de anúncios. Você configura a lógica de "Native Ad" uma vez e replica em todos os apps.  
3. **Migração Zero:** Quando for criar o SuperApp, você apenas adiciona as dependências dos apps individuais (que estarão modularizados) dentro dele.

## **3\. Stack Tecnológica Recomendada (2025)**

* **Gerência de Estado:** Riverpod (com Code Generation). É mais testável e modular que o Bloc para SuperApps, permitindo que cada módulo tenha seus providers isolados.  
* **Navegação:** GoRouter. Permite rotas profundas (Deep Linking) essenciais para quando juntar os apps.  
* **Banco de Dados Local:** Isar ou Hive (NoSQL super rápido para mobile).  
* **Injeção de Dependência:** get\_it \+ injectable.

## **4\. O Agente de IA e a Geração de Código**

Quando você solicitar à IA para criar um app, use este prompt de arquitetura:

"Crie o app \[NOME\] dentro da estrutura modular.

1. Use o package core\_ui para os widgets visuais.  
2. Implemente a lógica de negócio isolada (sem dependência direta da UI).  
3. Configure o AdMob usando o feature\_ads.  
4. Namespace: sa.rezende.\[nome\].  
5. Crie os arquivos .arb para Inglês e Português imediatamente."

## **5\. Cronograma de Execução (Beast Mode)**

### **Fase A: Fundação (1-2 Dias)**

* Configurar o Monorepo (Melos é recomendado para gerenciar os pacotes).  
* Criar packages/core\_ui (Tema, Cores, Componentes Básicos).  
* Criar packages/feature\_ads (Helper de AdMob).

### **Fase B: Fábrica de Apps (Contínuo)**

* Desenvolver App 1 (ex: Utilitário). Validar. Publicar.  
* Desenvolver App 2 (ex: Jogo Simples). Validar. Publicar.  
* *Nota:* Graças à Fase A, o App 2 já nasce com o design e os ads do App 1 configurados.

### **Fase C: A Fusão (Futuro)**

* Criar o projeto super\_app.  
* Importar as lógicas dos Apps 1 e 2 como "Features".  
* Criar uma "Home" unificadora que navega para essas features.

**Fim do Planejamento.** Mantenha o foco. Codifique uma feature, termine, valide, commite. Não deixe pontas soltas.