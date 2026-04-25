# 🇮🇳 ADHIKAR - Your Right. Delivered.

<div align="center">

**Government Welfare Scheme Navigator for Rural India**


[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-orange.svg)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Problem Statement](#-problem-statement)
- [Solution](#-solution)
- [Features](#-features)
- [Technology Stack](#-technology-stack)
- [Architecture](#-architecture)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [Project Structure](#-project-structure)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌟 Overview

**Adhikar** is a voice-first, offline-capable Flutter application that helps rural Indian citizens discover and apply for government welfare schemes they're eligible for. Using AI-powered profile extraction and intelligent eligibility matching, Adhikar bridges the gap between citizens and their entitled benefits.

**Tagline:** "Know. Claim. Empower."

---

## 🎯 Problem Statement

India has **733+ central and state welfare schemes** worth ₹15+ lakh crore annually, yet **₹1.7 lakh crore in benefits go unclaimed every year** because:

- Citizens don't know which schemes they qualify for
- Application forms are in English, complex, and multi-step
- Middlemen (dalals) charge bribes to help with applications
- No single source of truth for eligibility criteria
- Illiterate/semi-literate rural population can't navigate e-government portals

---

## 💡 Solution

Adhikar solves this by:

1. **Voice Input**: Users describe their situation in any Indian language
2. **AI Extraction**: Gemini AI extracts structured profile information
3. **Smart Matching**: Rule-based eligibility engine matches 50+ schemes
4. **Auto-Generated Forms**: Pre-filled PDF applications ready for submission
5. **Offline-First**: Works without internet, syncs when connected
6. **Multi-Language**: Supports 10+ Indian languages

---

## ✨ Features

### Core Features

- 🎤 **Voice-First Interface**: Speech-to-text in 10+ Indian languages
- 🤖 **AI Profile Extraction**: Gemini-powered intelligent data extraction
- 📊 **Smart Eligibility Engine**: Rule-based matching with confidence scores
- 📄 **Auto-Generated Forms**: PDF forms pre-filled with user data
- 📡 **Offline-First Architecture**: Works without internet
- 🔔 **Push Notifications**: Application status updates via FCM
- 📍 **Office Locator**: Find nearest government offices/CSCs
- 🔊 **Text-to-Speech**: Results read aloud for accessibility

### Government-Style Design

- 🎨 Professional color scheme (Navy Blue + Saffron)
- 📱 Clean, accessible UI following government standards
- ♿ Accessibility-first design (large fonts, screen reader support)
- 🌐 Multi-language support (Hindi, Marathi, Tamil, Telugu, etc.)

### Database

- 🗄️ **50+ Government Schemes**: Agriculture, Health, Education, Housing, Women & Child, Employment, Disability
- 📋 **Detailed Eligibility Criteria**: Age, income, caste, occupation, etc.
- 📄 **Document Requirements**: Clear list of required documents for each scheme

---

## 🛠 Technology Stack

### Frontend
- **Flutter 3.0+**: Cross-platform mobile app framework
- **Dart**: Programming language

### Google Technologies
- **Gemini 1.5 Flash**: AI for NLU and profile extraction
- **Firebase Firestore**: Cloud database for sync
- **Firebase Auth**: User authentication
- **Firebase Storage**: Document storage
- **Firebase Cloud Messaging**: Push notifications
- **Google ML Kit**: On-device language detection and OCR
- **Google Maps Platform**: Office locator

### State Management
- **Flutter BLoC**: State management pattern

### Local Storage
- **Hive**: NoSQL offline database
- **SQLQe:Frache
- **SharedPreferences**: Settings

### Other Libraries
- **speech_to_text**: Speech recognition
- **flutter_tts**: Text-to-speech
- *** centHTTP
- **pdf**: PDF generation
- **printing**: PDF printing/sharing
- **connectivity_plus**: Network monitoring
- **flutter_animate**: Animations
- **google_fonts**: Typography

---

## 🏗 Architecture

### Clean Architecture Pattern

```
lib/
├── main.dart                      # App entry point
├── app/                           # App-level configuration
│   ├── app.dart                   # Root widget
│   └── router.dart                # Navigation routing
├── core/                          # Core functionality
│   ├── theme/                     # Design system
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   ├── constants/                 # App constants
│   │   ├── api_endpoints.dart
│   │   ├── hive_boxes.dart
│   │   ├── scheme_categories.dart
│   │   └── supported_languages.dart
│   ├── services/                  # Core services
│   │   ├── voice_service.dart
│   │   ├── tts_service.dart
│   │   ├── connectivity_service.dart
│   │   ├── offline_queue_service.dart
│   │   └── sync_service.dart
│   └── utils/                     # Utilities
│       ├── eligibility_engine.dart
│       └── pdf_generator.dart
├── features/                      # Feature modules
│   ├── onboarding/                # Onboarding flow
│   ├── voice_intake/              # Voice capture
│   ├── profile/                   # Profile management
│   ├── schemes/                   # Scheme discovery
│   ├── application/               # Application forms
│   └── tracking/                  # Status tracking
└── data/                          # Data layer
    ├── models/                    # Data models
    ├── local/                     # Local data
    │   └── schemes_database.dart
    └── remote/                    # Remote services
        ├── gemini_service.dart
        └── firebase_service.dart
```

### Firebase-Only Architecture

```
Flutter App
│
├── Firebase Auth          → Phone OTP login
├── Cloud Firestore        → All data (schemes, profiles, applications)
├── Firebase Storage       → Document uploads (Aadhar, photos)
├── Cloud Functions        → Backend logic (AI matching, notifications)
├── Firebase Messaging     → Push notifications
└── Scheduled Functions    → Daily reminders
```

### Offline-First Flow

```
User Opens App (No Internet)
         ↓
Load schemes from Firestore cache (50+ schemes)
         ↓
Voice capture works (on-device speech_to_text)
         ↓
Profile extraction: OFFLINE FALLBACK MODE
  → Simple keyword matching
  → Rule-based eligibility (no Gemini needed)
  → Store result in Hive
         ↓
Show matching schemes ✅
         ↓
Internet detected? ──YES──▶ Sync to Firestore
         ↓                   Call Cloud Functions for AI matching
         NO
         ↓
Continue offline, queue sync tasks
```

---

## 📦 Installation

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development - macOS only)
- A Firebase project

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/adhikar.git
   cd adhikar
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Add Android app with package name `com.adhikar.app`
   - Download `google-services.json` and place it in `android/app/`
   - For iOS, download `GoogleService-Info.plist` and place it in `ios/Runner/`

4. **Set up Gemini API**
   - Get API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Create `.env` file in project root (see Configuration section)

5. **Run the app**
   ```bash
   flutter run
   ```

---

## ⚙️ Configuration

### Environment Variables

Create a `.env` file in the project root:

```env
# Gemini API Configuration
GEMINI_API_KEY=your_gemini_api_key_here

# Firebase Configuration
# (Automatically configured via google-services.json)

# Backend API Configuration (Optional)
BACKEND_API_URL=https://api.adhikar.gov.in
BACKEND_API_KEY=your_backend_api_key_here

# App Configuration
APP_ENV=development
ENABLE_OFFLINE_MODE=true
ENABLE_ANALYTICS=false
```

### Android Configuration

Add permissions in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### iOS Configuration

Add permissions in `ios/Runner/Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for voice input</string>
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for document scanning</string>
```

---

## 🚀 Usage

### User Flow

1. **Language Selection**: Choose preferred language (Hindi, Marathi, Tamil, etc.)
2. **Voice Input**: Describe your situation (age, income, occupation, family, etc.)
3. **Profile Review**: Verify and edit extracted information
4. **Scheme Discovery**: View all eligible schemes with benefit amounts
5. **Scheme Details**: See full scheme information, eligibility reasons, documents
6. **Application Form**: Auto-generated PDF form ready for download
7. **Track Status**: Monitor application status and receive updates

### Demo Script

**Persona**: Sunita Devi, 45, Widow Farmer, Bihar

1. Select Bhojpuri/Hindi language
2. Tap mic and speak:
   > "Hamaar naam Sunita Devi hai. Hum Bihar ke Gaya jila mein rehti hai. Hum vidhwa hai, hamare pati 3 saal pehle gaye. Hamare paas 1.5 acre zameen hai. Teen bacche hai, do school mein padh rahe hai. Mahine mein 4-5 hazaar kamaati hoon khet kaam karke. BPL card aur Aadhar hai, bank account bhi hai."

3. App extracts profile automatically
4. Results: **14 schemes found worth ₹1,12,000/year**
5. View scheme details, download form
6. Visit near
├── functions/                      # Firebase Cloud Functions
│   ├── index.js                    # Main functions fileest CSC with documents
│   packge.jso
│   └── .env
├── an
---

## 📁 Project Structure

```
├── docs/                           # Documentation
│   └── FIRESTORE_STRUCTURE.md
├── firebase.json                   # Firebase configuration
├── firestore.rules                 # Firestore security rules
adh storage.rulesi                  # Storage security rules
├── kar/ Originald
├── lib/
│   ├── main.dart
│   ├── app/
│   ├── core/
│   ├── features/
│   └── data/
├── android/
├── ios/
├── assets/
│   ├── animations/
│   ├── images/
│   └── icons/
├── files/                          # Documentation
│   ├── 01_OVERVIEW.md
│   ├── 02_TECHNICAL_ARCHITECTURE.md
│   └── 03_SCHEMES_AND_BUILDPLAN.md
├── pubspec.yaml
├── .env.example
├── README.md
└── LICENSE
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines
uages supported
- **Zero server management** with Firebase Functions
- **Auto-scales to millions** with Firestore
- **Real-time updates** with Firestore snapshots

## 🎯 Firebase-Only Benefits

- ✅ **Zero server management** - No EC2, Docker, or deployment headaches
- ✅ **Auto-scales** - Firestore handles any load atomtically
- ✅ **Real-time by default** - `snapshots()` ivlive tats udates free
- ✅ **Offline built-in** - Firestore has native offline ersistence
- ✅ **Generous free tier** - 1M Cloud Function calls/month free

- Follow Flutter style guide
- Write clean, documented code
- Add tests for new features
- Update documentation as needed
- Ensure government-style design consistency

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🏆 Impact Metrics

- **800 million** rural Indians potentially underserved
- **8-12** average schemes eligible per citizen
- **₹40,000-₹80,000** average unclaimed benefit per family/year
- **90 seconds** time to discover eligible schemes
- **50+** government schemes in database
- **10+** Indian languages supported

---

## 📞 Support

For questions or support:
- Open an issue on GitHub
- Email: support@adhikar.gov.in (placeholder)

---

## 🙏 Acknowledgments

- Google for providing Gemini AI and Firebase
- Government of India for welfare schemes
- Flutter community for excellent framework
- All contributors and supporters

---

<div align="center">

**Built with ❤️ for Bharat**

**Your Right. Delivered.** 🇮🇳

</div>
#   A d h i k a r  
 