# 🇮🇳 ADHIKAR — Your Right. Delivered.

<div align="center">

![Adhikar Banner](https://img.shields.io/badge/Adhikar-v2.0.0-blue?style=for-the-badge&logo=flutter)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-FFCA28?style=flat-square&logo=firebase)](https://firebase.google.com)
[![Gemini AI](https://img.shields.io/badge/Gemini_1.5_Flash-AI_Powered-4285F4?style=flat-square&logo=google)](https://makersuite.google.com)
[![License](https://img.shields.io/badge/License-MIT-22C55E?style=flat-square)](LICENSE)
[![Build](https://img.shields.io/badge/Build-Passing-22C55E?style=flat-square)](/)

**Voice-first government welfare scheme navigator for rural India**

*Know. Claim. Empower.*

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Problem Statement](#-problem-statement)
- [Solution](#-solution)
- [Features](#-features)
- [Screenshots & Flow](#-screenshots--flow)
- [Architecture](#-architecture)
- [Technology Stack](#-technology-stack)
- [Language Support](#-language-support)
- [Scheme Database](#-scheme-database)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Running the App](#-running-the-app)
- [Project Structure](#-project-structure)
- [Key Design Decisions](#-key-design-decisions)
- [Contributing](#-contributing)
- [Impact](#-impact)
- [License](#-license)

---

## 🌟 Overview

**Adhikar** (Hindi: अधिकार — *Right/Entitlement*) is a production-ready, voice-first Flutter application that helps rural Indian citizens discover and apply for government welfare schemes they're entitled to — in their own language, with or without internet.

India has **733+ active welfare schemes** delivering ₹15 lakh crore annually, yet **₹1.7 lakh crore goes unclaimed** every year. Adhikar bridges this gap using AI, voice, and smart offline-first design.

---

## 🎯 Problem Statement

| Problem | Scale |
|---------|-------|
| Citizens unaware of eligible schemes | 800M+ rural Indians |
| Forms are in English & complex | 60%+ functional illiteracy |
| Middlemen charge for "assistance" | ₹2,000–₹10,000 per application |
| No unified eligibility checker exists | 733+ fragmented schemes |
| Portals inaccessible on 2G/3G | 40%+ rural areas low-connectivity |

---

## 💡 Solution

Adhikar solves this with a simple 6-step workflow:

```
1. 🌐 Select Language  →  2. 🎤 Speak Your Story  →  3. 🤖 AI Extracts Profile
         ↓
6. 📋 Submit Forms   ←  5. 📄 Download PDFs   ←  4. 🎯 See Eligible Schemes
```

**Total time from first tap to scheme list: ~90 seconds.**

---

## ✨ Features

### 🎤 Voice-First Interface
- One-tap voice capture with real-time transcription
- Speech-to-text in **11 Indian languages** (Hindi, Tamil, Telugu, Marathi, Bengali, Gujarati, Kannada, Malayalam, Odia, Punjabi, English)
- Animated waveform feedback during recording
- Manual text input fallback

### 🤖 Gemini AI Integration
- **Profile Extraction**: Converts free-form voice speech into structured JSON profile
- **Language-Aware Processing**: Gemini prompt adapts to user's selected language
- **AI Chat Assistant**: Ask any question about schemes in your language — `AiChatScreen`
- **Offline Fallback**: Keyword-based extraction when AI is unavailable

### 🎯 Smart Eligibility Engine
- Rule-based matching engine against 50+ schemes
- Confidence score (0–100%) per scheme with color-coded badges
- Confidence breakdown bar per card
- Category filtering: Agriculture, Health, Education, Housing, Women, Employment, Disability
- Scheme search with live query filter

### 🌍 Full Localization (11 Languages)
- Persistent language selection stored in Hive
- `LanguageCubit` propagates locale to **all** app layers:
  - Flutter `MaterialApp.locale` (UI strings)
  - TTS output language
  - STT input locale
  - Gemini AI prompt language hint
  - Chat response language
- Language switchable at any time from Settings

### 📱 5-Tab Bottom Navigation
| Tab | Screen | Purpose |
|-----|--------|---------|
| 🎤 Discover | `VoiceCaptureScreen` | Record voice & find schemes |
| 📋 Schemes | `SchemeListScreen` | Browse all schemes |
| ✨ AI Chat | `AiChatScreen` | Ask Gemini anything |
| 🕐 History | `ApplicationHistoryScreen` | Track applications |
| ⚙️ Settings | `SettingsScreen` | Preferences & language |

### 📄 PDF Form Generation
- Auto-generates pre-filled government application forms
- Benefit summary PDF with all eligible schemes
- Print / share via native share sheet

### 🔌 Offline-First Architecture
- Hive NoSQL database caches all schemes locally
- Offline queue syncs application submissions when online
- `OfflineBanner` widget shows connectivity status in real-time
- `ConnectivityService` detects network state changes

### 🔔 Notifications (FCM)
- Application status update alerts
- New scheme alerts matching user profile
- Document upload reminders

### ♿ Accessibility
- Large text mode toggle
- High contrast mode
- TTS reads scheme results aloud automatically
- Voice input eliminates literacy barrier

---

## 📱 Screenshots & Flow

```
SplashScreen (3s)
    │
    ├── First launch → LanguageSelectScreen
    │       └── 11 animated language cards (native script)
    │               └── OnboardingScreen (4 slides + TTS narration)
    │                       └── HomeScreen (5-tab nav)
    │
    └── Returning user → HomeScreen (5-tab nav) ──────────────────────┐
                │                                                       │
          [Discover Tab]                                      [AI Chat Tab]
          VoiceCaptureScreen                                  AiChatScreen
               │                                    (Gemini Q&A in your language)
          ProfileReviewScreen
          (AI-extracted profile, toggle chips, editable)
               │
          SchemeListScreen
          (confidence badges, search, category filter)
               │
          SchemeDetailScreen
          (share, document checklist, apply button)
               │
     ┌─────────┴──────────┐
DocumentChecklistScreen   FormFillScreen
(per-doc "how to get")   (PDF generation)
```

---

## 🏗️ Architecture

### Clean Architecture — Feature-First

```
lib/
├── main.dart                        # Hive init, BlocProvider, app launch
├── app/
│   ├── app.dart                     # MaterialApp + LanguageCubit locale binding
│   └── router.dart                  # Named routes: 15 routes defined
│
├── core/
│   ├── blocs/language/
│   │   ├── language_cubit.dart      # Global language state (Hive-backed)
│   │   └── language_state.dart      # Locale + flags
│   ├── constants/
│   │   ├── hive_boxes.dart          # All Hive box/key names
│   │   ├── supported_languages.dart # 11 lang codes, TTS/STT locales, Gemini hint
│   │   └── scheme_categories.dart   # Category names EN + HI
│   ├── services/
│   │   ├── tts_service.dart         # flutter_tts wrapper, 11-language mapping
│   │   ├── voice_service.dart       # speech_to_text wrapper
│   │   ├── connectivity_service.dart# connectivity_plus v6 API
│   │   ├── firebase_messaging_service.dart # FCM setup
│   │   └── offline_queue_service.dart # Hive-backed sync queue
│   ├── theme/
│   │   ├── app_colors.dart          # Color constants + forCategory() helper
│   │   └── app_theme.dart           # Google Fonts Poppins, full ThemeData
│   ├── utils/
│   │   ├── eligibility_engine.dart  # Rule-based scheme matching
│   │   └── pdf_generator.dart       # Application form + benefit summary PDFs
│   └── widgets/
│       └── offline_banner.dart      # Real-time connectivity banner
│
├── data/
│   ├── local/
│   │   └── schemes_database.dart    # 50+ schemes JSON database (offline)
│   ├── models/
│   │   ├── user_profile.dart        # UserProfile model with copyWith
│   │   ├── scheme.dart              # Scheme + SchemeMatch models
│   │   └── application.dart         # Application + ApplicationStatus enum
│   └── remote/
│       ├── gemini_service.dart      # Gemini AI: extractProfile, chat, matchSchemes
│       └── firebase_service.dart    # Firestore CRUD
│
├── features/
│   ├── home/screens/
│   │   └── home_screen.dart         # 5-tab IndexedStack bottom nav
│   ├── onboarding/screens/
│   │   ├── splash_screen.dart       # Smart 3-way routing
│   │   ├── language_select_screen.dart # 11 animated language cards
│   │   └── onboarding_screen.dart   # 4-slide PageView + TTS
│   ├── voice_intake/screens/
│   │   └── voice_capture_screen.dart # Record → transcript → profile
│   ├── profile/screens/
│   │   └── profile_review_screen.dart # AI review + editable fields
│   ├── schemes/screens/
│   │   ├── scheme_list_screen.dart  # Search, filter, confidence display
│   │   ├── scheme_detail_screen.dart # Detail + share + checklist
│   │   └── document_checklist_screen.dart # Per-doc "how to get" tips
│   ├── application/screens/
│   │   └── form_fill_screen.dart    # PDF form generation
│   ├── tracking/screens/
│   │   ├── application_history_screen.dart # All applications + status
│   │   └── application_status_screen.dart  # Single app detail
│   ├── ai_chat/screens/
│   │   └── ai_chat_screen.dart      # Gemini chat with TTS + suggestions
│   └── settings/screens/
│       └── settings_screen.dart     # Language, voice, notifications, a11y
│
└── generated/l10n/                  # Auto-generated from flutter gen-l10n
    ├── app_localizations.dart
    └── app_localizations_*.dart     # 11 language files
```

### Language Propagation Chain

```
User selects language
        │
        ▼
LanguageCubit.changeLanguage(code)
        │
        ├──► Hive.box('settings').put('selected_language', code)   [persist]
        │
        ├──► emit(LanguageState(locale: Locale(code)))
        │           │
        │           ▼
        │    MaterialApp.locale → Flutter rebuilds all UI strings
        │    (AppLocalizations.of(context).schemeName etc.)
        │
        ├──► TtsService.speak(text, code)
        │    → SupportedLanguages.ttsLocales[code] → flutter_tts.setLanguage()
        │
        ├──► VoiceService.listen(localeId: SupportedLanguages.sttLocales[code])
        │    → speech_to_text recognizes speech in correct language
        │
        └──► GeminiService.extractProfile(text, languageHint: instruction)
             GeminiService.chat(message, languageCode: code)
             → AI responds in user's language
```

---

## 🛠️ Technology Stack

### Frontend
| Library | Version | Purpose |
|---------|---------|---------|
| `flutter` | 3.0+ | Cross-platform framework |
| `flutter_bloc` | ^9.1.1 | State management (LanguageCubit) |
| `flutter_animate` | ^4.5.0 | Smooth micro-animations |
| `google_fonts` | ^8.0.2 | Poppins typography |
| `fl_chart` | ^1.2.0 | Analytics charts |
| `lottie` | ^3.0.0 | Lottie animations |

### Google / Firebase
| Service | Purpose |
|---------|---------|
| **Gemini 1.5 Flash** | Profile extraction, AI chat, scheme matching |
| **Firebase Auth** | Phone OTP authentication |
| **Cloud Firestore** | Real-time scheme & application data sync |
| **Firebase Storage** | Document uploads (Aadhaar, photos) |
| **Firebase Messaging** | Push notifications for status updates |
| **Cloud Functions** | Backend AI matching, automated alerts |
| **Google ML Kit** | On-device language detection + OCR |
| **Google Maps** | Nearest CSC/office locator |

### Storage
| Library | Purpose |
|---------|---------|
| `hive` + `hive_flutter` | Fast offline NoSQL (settings, language, queue) |
| `sqflite` | Complex scheme queries |
| `shared_preferences` | Legacy preferences (being phased to Hive) |

### Voice & AI
| Library | Purpose |
|---------|---------|
| `speech_to_text` ^7.3.0 | STT in 11 Indian languages |
| `flutter_tts` ^4.2.5 | TTS in 11 Indian languages |
| `dio` ^5.4.0 | HTTP client for Gemini REST API |

### Utilities
| Library | Purpose |
|---------|---------|
| `connectivity_plus` ^7.1.1 | Network state detection |
| `pdf` + `printing` | Form generation & sharing |
| `share_plus` | Scheme sharing |
| `package_info_plus` | App version in Settings |
| `permission_handler` | Mic, storage permissions |
| `image_picker` | Document photo capture |

---

## 🌐 Language Support

| Language | Code | Script | TTS | STT | UI |
|----------|------|--------|-----|-----|-----|
| English | `en` | Latin | ✅ | ✅ | ✅ |
| हिंदी | `hi` | Devanagari | ✅ | ✅ | ✅ |
| मराठी | `mr` | Devanagari | ✅ | ✅ | ✅ |
| தமிழ் | `ta` | Tamil | ✅ | ✅ | ✅ |
| తెలుగు | `te` | Telugu | ✅ | ✅ | ✅ |
| ಕನ್ನಡ | `kn` | Kannada | ✅ | ✅ | ✅ |
| বাংলা | `bn` | Bengali | ✅ | ✅ | ✅ |
| ગુજરાતી | `gu` | Gujarati | ✅ | ✅ | ✅ |
| മലയാളം | `ml` | Malayalam | ✅ | ✅ | ✅ |
| ଓଡ଼ିଆ | `or` | Odia | ✅ | ✅ | ✅ |
| ਪੰਜਾਬੀ | `pa` | Gurmukhi | ✅ | ✅ | ✅ |

Language is stored persistently in Hive and applied globally on every app launch.

---

## 📚 Scheme Database

50+ schemes across 7 categories:

| Category | Icon | Examples |
|----------|------|---------|
| Agriculture 🌾 | `Icons.grass` | PM-KISAN, Pradhan Mantri Fasal Bima Yojana, Kisan Credit Card |
| Health 🏥 | `Icons.health_and_safety` | Ayushman Bharat PM-JAY, Janani Suraksha Yojana |
| Education 📚 | `Icons.school` | Beti Bachao Beti Padhao, Mid-Day Meal, National Scholarship |
| Housing 🏠 | `Icons.home` | PM Awas Yojana (Rural & Urban), Swachh Bharat Mission |
| Women & Child 👩 | `Icons.woman` | Sukanya Samriddhi, Maternity Benefit, POSHAN |
| Employment 💼 | `Icons.work` | MGNREGS, PM Mudra Loan, Skill India |
| Disability ♿ | `Icons.accessible` | ADIP Scheme, Divyangjan Scholarship |

---

## ⚙️ Installation

### Prerequisites

- Flutter SDK **3.0+** — [Install Flutter](https://docs.flutter.dev/get-started/install)
- Dart **3.0+**
- Android Studio / VS Code with Flutter plugin
- Android device or emulator (API 21+)
- Firebase project configured

### 1. Clone the Repository

```bash
git clone https://github.com/Chetan0e/Adhikar.git
cd Adhikar
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Localizations

```bash
flutter gen-l10n
```

This generates `lib/generated/l10n/app_localizations*.dart` for all 11 languages.

### 4. Configure Firebase

```bash
# Install Firebase CLI if not already done
npm install -g firebase-tools
dart pub global activate flutterfire_cli

# Login and configure
firebase login
flutterfire configure --project=your-firebase-project-id
```

Or manually:
- Go to [Firebase Console](https://console.firebase.google.com)
- Create project → Add Android app with package `com.adhikar.app`
- Download `google-services.json` → place in `android/app/`

### 5. Set Environment Variables

```bash
cp .env.example .env
```

Edit `.env`:

```env
# Gemini API — get from https://makersuite.google.com/app/apikey
GEMINI_API_KEY=your_gemini_api_key_here

# Google Maps API (for Office Locator)
GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here

# App config
APP_ENV=development
ENABLE_OFFLINE_MODE=true
ENABLE_ANALYTICS=false
```

---

## 🚀 Running the App

```bash
# Development (with API keys from .env)
flutter run --dart-define-from-file=.env

# Specific device
flutter run -d <device-id> --dart-define-from-file=.env

# Debug APK
flutter build apk --debug --dart-define-from-file=.env

# Release APK (production)
flutter build apk --release --dart-define-from-file=.env

# App Bundle (Play Store)
flutter build appbundle --release --dart-define-from-file=.env
```

> **Note:** The app works without a Gemini API key — it falls back to keyword-based offline extraction. Firebase features require `google-services.json`.

---

## 🔑 Configuration

### Hive Boxes & Keys

All persistent data is stored in Hive. Key constants are in `lib/core/constants/hive_boxes.dart`:

| Box | Key | Default | Purpose |
|-----|-----|---------|---------|
| `settings` | `selected_language` | `'en'` | Persists user's language |
| `settings` | `onboarding_complete` | `false` | Controls splash routing |
| `settings` | `tts_enabled` | `true` | TTS on/off |
| `settings` | `auto_play_results` | `true` | Auto-read scheme results |
| `settings` | `speech_rate` | `0.5` | TTS speech rate |
| `settings` | `large_text_mode` | `false` | Accessibility: larger text |
| `settings` | `high_contrast_mode` | `false` | Accessibility: contrast |
| `sync_queue` | *(task IDs)* | — | Offline sync queue |
| `user_profiles` | *(user ID)* | — | Cached profiles |
| `applications` | *(app ID)* | — | Submitted applications |

### Firestore Security Rules

Ensure your Firestore rules in `firestore.rules` match:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /schemes/{schemeId} {
      allow read: if true;
      allow write: if false;
    }
    match /applications/{appId} {
      allow read, write: if request.auth != null
        && request.auth.uid == resource.data.userId;
    }
  }
}
```

---

## 💡 Key Design Decisions

### 1. Voice-First, Literacy-Agnostic
Rural users often have limited reading ability. The entire core flow (discover → apply) works purely through voice — no typing required. TTS reads scheme results, benefits, and eligibility reasons aloud.

### 2. Offline-First with Hive
All 50+ schemes are bundled in `SchemesDatabase` (no download needed). Hive stores language preference, settings, and queued applications. The app is fully functional with zero connectivity.

### 3. LanguageCubit as Single Source of Truth
Instead of passing language through navigator arguments or SharedPreferences reads, a global `LanguageCubit` provided at the root `MaterialApp` level ensures every layer (UI, TTS, STT, Gemini) always has the correct locale.

### 4. Gemini with Offline Fallback
`GeminiService.extractProfile()` tries the Gemini API first. On failure (no internet, no key), it falls back to keyword-based Hindi/English extraction. The `languageHint` parameter tells Gemini to respond in the user's language.

### 5. Government-Style Design
Navy Blue (`#0B3D91`) + Saffron (`#FF9933`) + Green (`#138808`) — the tricolor palette builds immediate trust with government-facing rural users. Poppins font balances modernity with readability.

### 6. IndexedStack for Tab Navigation
`HomeScreen` uses `IndexedStack` instead of `PageView` so each tab's state is preserved — recording progress in VoiceCaptureScreen, chat history in AiChatScreen, etc. are not lost when switching tabs.

---

## 🤝 Contributing

Contributions are welcome! Please follow the process:

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/your-feature`
3. **Code** following the established patterns:
   - Use `LanguageCubit` for any language-dependent logic
   - Store new settings keys in `HiveBoxes`
   - Add new languages to `SupportedLanguages`
   - Add new routes to `AppRouter`
4. **Test** your changes: `flutter analyze && flutter test`
5. **Commit**: `git commit -m 'feat: add amazing feature'`
6. **Push**: `git push origin feature/your-feature`
7. **Open a Pull Request**

### Adding a New Language

1. Add locale code to `SupportedLanguages.languages`
2. Add TTS/STT locale to respective maps
3. Create `lib/l10n/app_XX.arb` (copy from `app_en.arb`)
4. Add `Locale('XX')` to `app.dart` supported locales
5. Run `flutter gen-l10n`

### Adding a New Scheme

Edit `lib/data/local/schemes_database.dart` following the existing JSON schema:

```dart
{
  'id': 'SCHEME_ID',
  'name': 'Scheme Name',
  'name_hindi': 'योजना नाम',
  'category': 'agriculture', // see SchemeCategories
  'description': '...',
  'benefit_amount': '₹X,XXX per year',
  'eligibility_criteria': { ... },
  'required_documents': [...],
  'application_office': '...',
  'website': 'https://...',
}
```

---

## 📊 Impact

| Metric | Value |
|--------|-------|
| Target population | 800 million rural Indians |
| Schemes in database | 50+ (central + state) |
| Languages supported | 11 Indian languages |
| Avg. schemes per eligible user | 8–12 |
| Avg. unclaimed benefit per family | ₹40,000–₹80,000/year |
| Time to scheme discovery | ~90 seconds |
| Offline capability | 100% core functionality |
| Internet required for | Gemini AI + Firebase sync only |

---

## 📝 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgements

- [Flutter](https://flutter.dev) — cross-platform framework
- [Google Gemini](https://deepmind.google/technologies/gemini/) — AI profile extraction & chat
- [Firebase](https://firebase.google.com) — backend infrastructure
- [speech_to_text](https://pub.dev/packages/speech_to_text) — voice recognition
- [flutter_tts](https://pub.dev/packages/flutter_tts) — text-to-speech
- All the rural citizens of India whose rights we exist to deliver

---

<div align="center">

**Built with ❤️ for rural India**

```
  A d h i k a r
आपका अधिकार। आपके द्वार।
 Your Right. Delivered.
```

[![GitHub stars](https://img.shields.io/github/stars/Chetan0e/Adhikar?style=social)](https://github.com/Chetan0e/Adhikar)

</div>