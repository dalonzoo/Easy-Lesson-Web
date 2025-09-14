# EasyLesson Web

Applicazione multi-piattaforma sviluppata in Flutter per la visualizzazione e la gestione semplificata degli orari scolastici. Il progetto è pensato per essere eseguito su Web, Android, iOS e piattaforme Desktop da un'unica codebase.

## 📜 Indice

- [Architettura](#-architettura)
  - [Framework Multi-Piattaforma](#-framework-multi-piattaforma)
  - [Gestione dello Stato](#-gestione-dello-stato)
  - [Design Responsivo](#-design-responsivo)
  - [Struttura a Componenti](#-struttura-a-componenti)
  - [Layer Dati](#-layer-dati)
- [🚀 Tecnologie Implementate](#-tecnologie-implementate)
  - [Core](#core)
  - [Backend & Database](#backend--database)
  - [UI & Design](#ui--design)
- [📂 Struttura del Progetto](#-struttura-del-progetto)
- [⚙️ Come Iniziare](#️-come-iniziare)
  - [Prerequisiti](#prerequisiti)
  - [Installazione ed Esecuzione](#installazione-ed-esecuzione)
- [📦 Build per la Produzione](#-build-per-la-produzione)

---

## 🏛️ Architettura

L'architettura di EasyLesson Web è stata progettata per essere scalabile, manutenibile e performante, sfruttando i punti di forza del framework Flutter.

### 🌐 Framework Multi-Piattaforma

Il progetto è costruito utilizzando **Flutter**, che consente di compilare l'applicazione per diverse piattaforme (Web, Mobile, Desktop) partendo da un'unica codebase scritta in linguaggio **Dart**. Questo garantisce coerenza visiva e funzionale su tutti i dispositivi.

### 🔄 Gestione dello Stato

Per la gestione dello stato dell'applicazione (es. la selezione della scheda corrente, i dati dell'orario), viene utilizzato un approccio reattivo. La logica di business è separata dalla UI, consentendo un flusso di dati unidirezionale e prevedibile. Il file `lib/utils/tab_controller_handler.dart` è un esempio di gestione centralizzata dello stato della navigazione a schede.

### 📱 Design Responsivo

L'interfaccia utente è progettata per essere completamente responsiva. Il widget `lib/utils/responsive_widget.dart` e il `lib/utils/view_wrapper.dart` lavorano insieme per adattare il layout in base alle dimensioni dello schermo, garantendo un'esperienza utente ottimale sia su grandi schermi desktop che su piccoli schermi di smartphone.

### 🧩 Struttura a Componenti

L'architettura della UI è basata su **widget riutilizzabili**. I widget generici e di base (come pulsanti, punti elenco, barre di navigazione) sono isolati nella directory `lib/widgets/`. Le pagine principali dell'applicazione, che assemblano questi widget, si trovano in `lib/pages/`. Questo approccio favorisce il riutilizzo del codice e la manutenibilità.

### 📊 Layer Dati

La logica di recupero dei dati è centralizzata e gestita dal `lib/utils/DataFetcher.dart`. Questo componente è responsabile del caricamento dei dati dell'orario (probabilmente da una fonte esterna come un file JSON o un'API) e della loro conversione in modelli di dati strutturati come `OrarioSettimanale`, `GiornoDetails`, e `Ora`, definiti nella directory `lib/utils/`. Questo disaccoppia la logica di business dalla fonte dei dati.

---

## 🚀 Tecnologie Implementate

### Core

- **[Flutter](https://flutter.dev/)**: Framework UI di Google per la creazione di applicazioni compilate in modo nativo per mobile, web e desktop da un'unica codebase.
- **[Dart](https://dart.dev/)**: Linguaggio di programmazione ottimizzato per la creazione di app veloci su qualsiasi piattaforma.

### Backend & Database

- **[Firebase](https://firebase.google.com/)**: La presenza dei file `firebase_options.dart` e `google-services.json` indica l'integrazione con la piattaforma Firebase. Le funzionalità utilizzate probabilmente includono:
  - **Firebase Core**: Per la connessione dell'app ai servizi Firebase.
  - **Cloud Firestore / Realtime Database** (potenziale): Per la memorizzazione e la sincronizzazione dei dati degli orari in tempo reale.

### UI & Design

- **[Material Design](https://material.io/)**: L'applicazione segue le linee guida di Material Design, utilizzando i widget forniti da Flutter.
- **Custom Widgets**: Numerosi widget personalizzati (`gradient_button`, `custom_tab_bar`, `bottom_bar`, etc.) per creare un'identità visiva unica.
- **Google Fonts**: La directory `assets/fonts/` e il probabile utilizzo del package `google_fonts` per una tipografia personalizzata e coerente.
- **Icone Personalizzate**: Il file `lib/utils/my_flutter_app_icons.dart` e i font in `assets/fonts/` suggeriscono l'uso di una suite di icone personalizzate.

---

## 📂 Struttura del Progetto

```
.
├── lib/
│   ├── main.dart               # Entry point dell'applicazione
│   ├── pages/                  # Widget che rappresentano le pagine principali
│   ├── utils/                  # Classi di utilità, modelli dati, helper
│   └── widgets/                # Widget riutilizzabili (componenti UI)
├── assets/
│   ├── fonts/                  # Font personalizzati
│   └── images/                 # Immagini e illustrazioni
├── web/                        # Codice specifico per la piattaforma Web
├── android/                    # Codice specifico per la piattaforma Android
├── ios/                        # Codice specifico per la piattaforma iOS
├── windows/                    # Codice specifico per la piattaforma Windows
├── macos/                      # Codice specifico per la piattaforma macOS
├── linux/                      # Codice specifico per la piattaforma Linux
└── pubspec.yaml                # Definizione del progetto e delle dipendenze
```

---

## ⚙️ Come Iniziare

Segui queste istruzioni per ottenere una copia del progetto funzionante sulla tua macchina locale per scopi di sviluppo e test.

### Prerequisiti

Assicurati di avere installato il **[Flutter SDK](https://docs.flutter.dev/get-started/install)**.

### Installazione ed Esecuzione

1.  **Clona il repository**
    ```sh
    git clone <URL_DEL_TUO_REPOSITORY>
    cd EasyLesson_web
    ```

2.  **Installa le dipendenze**
    Esegui questo comando dalla root del progetto per scaricare tutte le dipendenze necessarie.
    ```sh
    flutter pub get
    ```

3.  **Esegui l'applicazione**
    Puoi avviare l'app sulla piattaforma che preferisci. Per il web, usa:
    ```sh
    flutter run -d chrome
    ```
    Per altri dispositivi (se configurati):
    ```sh
    flutter run
    ```

---

## 📦 Build per la Produzione

Per creare una build ottimizzata per il rilascio, utilizza i comandi di build di Flutter.

- **Web:**
  ```sh
  flutter build web
  ```
  I file verranno generati nella directory `build/web`.

- **Android:**
  ```sh
  flutter build apk
  # oppure
  flutter build appbundle
  ```

- **iOS:**
  ```sh
  flutter build ios
  ```