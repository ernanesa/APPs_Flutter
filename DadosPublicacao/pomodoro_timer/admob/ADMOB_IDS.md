# AdMob IDs - Pomodoro Timer

**Data de Criação:** 14 de Janeiro de 2026  
**Conta AdMob:** ernane.sa@gmail.com  
**Console URL:** https://admob.google.com/v2/apps/1406247631/adunits/list

---

## App ID

| Campo        | Valor                                      |
| ------------ | ------------------------------------------ |
| **App Name** | Pomodoro Timer                             |
| **App ID**   | `ca-app-pub-9691622617864549~1406247631`   |
| **Platform** | Android                                    |
| **Status**   | Pendente revisão (app não publicado ainda) |

---

## Ad Units (Blocos de Anúncios)

### 1. Banner

| Campo       | Valor                                    |
| ----------- | ---------------------------------------- |
| **Nome**    | pomodoro_banner                          |
| **ID**      | `ca-app-pub-9691622617864549/3648255832` |
| **Formato** | Banner Adaptativo                        |
| **Uso**     | Rodapé das telas principais              |

### 2. Interstitial

| Campo       | Valor                                    |
| ----------- | ---------------------------------------- |
| **Nome**    | pomodoro_interstitial                    |
| **ID**      | `ca-app-pub-9691622617864549/7251608861` |
| **Formato** | Intersticial                             |
| **Uso**     | Após cada 3 sessões Pomodoro completadas |

### 3. App Open

| Campo       | Valor                                               |
| ----------- | --------------------------------------------------- |
| **Nome**    | pomodoro_app_open                                   |
| **ID**      | `ca-app-pub-9691622617864549/2957990691`            |
| **Formato** | Abertura do App                                     |
| **Uso**     | Quando o app volta ao foreground (após 2ª abertura) |

---

## Test IDs (Desenvolvimento)

Use estes IDs durante o desenvolvimento para evitar bloqueio da conta:

| Tipo              | Test ID                                  |
| ----------------- | ---------------------------------------- |
| Banner            | `ca-app-pub-3940256099942544/6300978111` |
| Interstitial      | `ca-app-pub-3940256099942544/1033173712` |
| App Open          | `ca-app-pub-3940256099942544/9257395921` |
| App ID (Manifest) | `ca-app-pub-3940256099942544~3347511713` |

---

## Arquivos Atualizados

1. **AndroidManifest.xml**: App ID de produção configurado
2. **ad_service.dart**: Todos os Ad Unit IDs de produção configurados

---

## Notas

- Os IDs de produção só são usados em builds de release (`kDebugMode == false`)
- Em debug mode, os IDs de teste são usados automaticamente
- Ads podem levar até 1 hora para começar a aparecer após a criação
- O app precisa ser aprovado na revisão do AdMob para monetizar
