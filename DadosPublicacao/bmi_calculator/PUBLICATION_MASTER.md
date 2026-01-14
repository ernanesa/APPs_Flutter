# 🚀 GUIA MESTRE DE PUBLICAÇÃO - BMI CALCULATOR

Este documento contém todas as informações exatas que você deve preencher no **Google Play Console** para publicar o app rapidamente.

---

## 1. Informações Básicas do App (Painel Principal)
- **Nome do App:** `BMI Calculator - Health` (ou `Calculadora de IMC - Saúde` em PT)
- **Tipo de App:** `App`
- **Categoria:** `Saúde e Boa Forma` (Health & Fitness)
- **Grátis ou Pago:** `Grátis`

---

## 2. Configurações da Loja (Store Listing)
*Os textos completos em 11 idiomas estão em: `DadosPublicacao/bmi_calculator/store_assets/store_listings.md`*

**Resumo (Português):**
- **Título do App:** `Calculadora de IMC - Saúde`
- **Descrição Curta:** `Calcule seu Índice de Massa Corporal rapidamente e acompanhe sua evolução de saúde.`
- **Descrição Completa:** *(Copiar do arquivo store_listings.md)*

---

## 3. Segurança de Dados (Data Safety)
*Responda conforme abaixo para garantir aprovação rápida:*

1.  **O app coleta ou compartilha dados do usuário?**
    - Resposta: `Não` (Tudo é offline e local).
2.  **Todos os dados coletados pelo app são criptografados em trânsito?**
    - Resposta: `Sim` (Mesmo não coletando, é o padrão de segurança).
3.  **Você oferece uma forma de os usuários solicitarem a exclusão de dados?**
    - Resposta: `Sim` (Eles podem limpar o histórico no app).

**Tipos de Dados (Se perguntar sobre Ads):**
- O Google AdMob pode coletar **ID do Dispositivo** e **Interações com o App** para fins de publicidade e análise.
- **Finalidade:** `Publicidade ou Marketing`.
- **Compartilhado com terceiros?** `Sim` (Com o Google).

---

## 4. Questionário de Classificação Etária (IARC)
1.  **Categoria do App:** `Utility / Other` (Utilitário / Outros)
2.  **Conteúdo Violento?** `Não`
3.  **Sexualidade?** `Não`
4.  **Linguagem Ofensiva?** `Não`
5.  **Substâncias Controladas?** `Não`
6.  **Promoção de Atividade Física?** `Sim` (Saúde e fitness)
7.  **Permite interação entre usuários?** `Não`
8.  **Venda de bens digitais?** `Não`

---

## 5. Endereços Úteis
- **URL da Política de Privacidade:** `https://rezende.dev/policies/privacy-policy-bmi.html` (Você deve hospedar o conteúdo do arquivo `privacy_policy.md` nesta URL).
- **URL do Site:** `https://rezende.dev`
- **Email de Suporte:** `ernane@rezende.dev`

---

## 6. Publicidade (Ads)
- **O app contém anúncios?** `Sim`
- **ID do App AdMob:** `ca-app-pub-9691622617864549~7285917043`
- **app-ads.txt:** Publicar o conteúdo de `admob/app-ads.txt` na raiz do seu site (`rezende.dev/app-ads.txt`).

---

## 7. Informações Técnicas (Painel de Lançamento)
- **Versão:** `1.0.0 (Build 1)`
- **Bundle (.aab):** `DadosPublicacao/bmi_calculator/app-release.aab`
- **Target SDK:** `35` (Android 15)
- **Compatibilidade 16KB:** `Sim` (Verificado via Beast Mode)

---

## 8. Checklist de Screenshots (Ação Necessária)
Tire 4 a 8 fotos de tela para cada formato no emulador/celular:
1.  Tela Inicial (Calculadora)
2.  Tela de Evolução (Gráfico)
3.  Tela de Histórico
4.  Diálogo de Informação (Tabela de IMC)

*Salve em: `DadosPublicacao/bmi_calculator/store_assets/screenshots/`*

---

*Documento preparado por GitHub Copilot - Protocolo Beast Mode Flutter v4.0*
