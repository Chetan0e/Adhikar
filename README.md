# ADHIKAR - Your Right. Delivered.

<div align="center">

**Government Welfare Scheme Navigator for Rural India**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-orange.svg)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

---

## Table of Contents

- [Overview](#overview)
- [Problem Statement](#problem-statement)
- [Solution](#solution)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Firebase-Only Benefits](#firebase-only-benefits)
- [Installation](#installation)
- [Usage & Demo Flow](#usage--demo-flow)
- [Contributing](#contributing)
- [Impact Metrics](#impact-metrics)
- [License](#license)

---

## Overview

**Adhikar** is a voice-first, offline-capable Flutter application that helps rural Indian citizens discover and apply for government welfare schemes they're eligible for. Using AI-powered profile extraction and intelligent eligibility matching, Adhikar bridges the gap between citizens and their entitled benefits.

**Tagline:** "Know. Claim. Empower."

---

## Problem Statement

India has **733+ central and state welfare schemes** worth ₹15+ lakh crore annually, yet **₹1.7 lakh crore in benefits go unclaimed every year** because:

- Citizens do not know which schemes they qualify for.
- Application forms are in English, complex, and multi-step.
- Middlemen charge bribes to assist with applications.
- No single source of truth exists for eligibility criteria.
- Illiterate or semi-literate rural populations cannot navigate complex e-government portals.

---

## Solution

Adhikar solves this by providing a simple, accessible workflow:

1. **Voice Input**: Users describe their situation in any Indian language.
2. **AI Extraction**: Gemini AI extracts structured profile information seamlessly.
3. **Smart Matching**: A rule-based eligibility engine matches 50+ schemes.
4. **Auto-Generated Forms**: Pre-filled PDF applications ready for submission.
5. **Offline-First**: Works entirely without internet access, syncing automatically when connected.
6. **Multi-Language**: Native support for 10+ Indian languages.

---

## Features

### Core Features

- **Voice-First Interface**: Speech-to-text natively processing 10+ Indian languages.
- **AI Profile Extraction**: Gemini-powered intelligent data extraction.
- **Smart Eligibility Engine**: Rule-based matching prioritizing confidence scores.
- **Auto-Generated Forms**: Localized PDF forms pre-filled with user data.
- **Offline-First Architecture**: Continuous operation in low-connectivity rural zones.
- **Push Notifications**: Real-time application status updates via FCM.
- **Office Locator**: Find the nearest government offices and Common Service Centres (CSCs) using Google Maps.
- **Text-to-Speech**: Application results are read aloud for visual accessibility.

### Government-Style Design

- **Professional Aesthetics**: Trustworthy color scheme (Navy Blue + Saffron).
- **Standards-Compliant UI**: Clean, accessible UI strictly following government usability standards.
- **Accessibility-First**: Designed with large typography and screen reader support.
- **Localization**: Multi-language support (Hindi, Marathi, Tamil, Telugu, etc.).

### Database Scope

- **Comprehensive Database**: 50+ key government schemes mapped across Agriculture, Health, Education, Housing, Women & Child, Employment, and Disability.
- **Detailed Eligibility Criteria**: Tracking parameters for age, income, caste, occupation, etc.
- **Document Requirements**: Clear, itemized lists of required documents per scheme.

---

## Technology Stack

### Frontend
- **Flutter 3.0+**: Cross-platform mobile application framework.
- **Dart**: Programming language.

### Google Technologies
- **Gemini 1.5 Flash**: Advanced AI for NLU and structured profile extraction.
- **Firebase Firestore**: Cloud database for real-time data synchronization.
- **Firebase Auth**: Secure user authentication.
- **Firebase Storage**: Reliable document storage for forms and IDs.
- **Firebase Cloud Messaging**: Dependable push notifications.
- **Google ML Kit**: On-device language detection and OCR.
- **Google Maps Platform**: Spatial location of service centers.

### State Management
- **Flutter BLoC**: Predictable state management pattern.

### Local Storage
- **Hive**: Blazing fast NoSQL offline database.
- **sqflite**: SQLite database for complex querying.
- **SharedPreferences**: Simple key-value store for preferences.

### Other Libraries
- **speech_to_text**: Native speech recognition.
- **flutter_tts**: Natively integrated Text-to-Speech.
- **dio**: Robust HTTP client for API interactions.
- **pdf & printing**: PDF generation and native printing/sharing.

---

## Architecture

### Clean Architecture Pattern

```text
lib/
├── main.dart                      # App entry point
├── app/                           # App-level configuration and routing
├── core/                          # Core functionality
│   ├── constants/                 # App constants (API, Hive, Colors)
│   ├── services/                  # Firebase, Sync, Connectivity services
│   ├── theme/                     # Unified Design system
│   └── utils/                     # Helpers (PDF, Eligibility Engine)
├── data/                          # Data layer
│   ├── local/                     # Local databases (Hive/sqflite)
│   ├── models/                    # Typed data models
│   └── remote/                    # API clients (Firebase, Gemini)
└── features/                      # Feature modules
    ├── application/               # Application forms logic
    ├── onboarding/                # First-launch onboarding flows
    ├── profile/                   # Profile extraction & management
    ├── schemes/                   # Scheme database & discovery
    ├── tracking/                  # Status tracking and analytics
    └── voice_intake/              # Voice capture UI & processing
```

### Firebase-Only Infrastructure

- **Firebase Auth**: Simple, secure Phone OTP login designed for rural access.
- **Cloud Firestore**: Synchronizes all critical data (schemes, profiles, applications).
- **Firebase Storage**: Handles document uploads (Aadhar, photos) securely.
- **Cloud Functions**: Executes backend logic (AI matching, automated notifications).
- **Firebase Messaging**: Pushes targeted notifications.

---

## Firebase-Only Benefits

- **Zero Server Management**: Eliminates EC2, Docker, or complex deployment environments.
- **Auto-Scales**: Firestore handles massive loads effortlessly and atomically.
- **Real-Time by Default**: Utilizes `snapshots()` to provide live status updates seamlessly.
- **Offline Built-In**: Native offline persistence guarantees rural functionality.
- **Generous Free Tier**: Up to 1M Cloud Function calls per month at no cost.

---

## Installation

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio or VS Code
- A configured Firebase Project

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/Chetan0e/Adhikar.git
   cd Adhikar
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Head to [Firebase Console](https://console.firebase.google.com/) and register your app (`com.adhikar.app`).
   - Download `google-services.json` and place it securely into `android/app/`.

4. **Environment Variables**
   - Duplicate `.env.example` and rename it to `.env`.
   - Update your configuration safely within `.env`. 
   - Ensure you provide keys for Gemini and Maps:
     ```env
     GEMINI_API_KEY=your_gemini_api_key_here
     GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here
     ```

5. **Run the App**
   ```bash
   flutter run --dart-define-from-file=.env
   ```

---

## Usage & Demo Flow

To understand the core Adhikar workflow, consider this example user journey:

**Persona**: Sunita Devi, 45, Widow Farmer, Bihar

1. **Language Selection**: Sunita opens the app and selects Bhojpuri/Hindi.
2. **Voice Input**: She taps the microphone and speaks naturally:
   > "Hamaar naam Sunita Devi hai. Hum Bihar ke Gaya jila mein rehti hai. Hum vidhwa hai, hamare pati 3 saal pehle gaye. Hamare paas 1.5 acre zameen hai. Teen bacche hai, do school mein padh rahe hai. Mahine mein 4-5 hazaar kamaati hoon khet kaam karke. BPL card aur Aadhar hai, bank account bhi hai."
3. **AI Extraction**: The application instantly processes this voice string and extracts a structured JSON profile using Gemini.
4. **Scheme Discovery**: Adhikar matches her profile against the local database, outputting: **14 schemes found worth ₹1,12,000/year**.
5. **Application**: She views the specific scheme details and downloads auto-filled PDF forms.
6. **Action**: Guided by Maps, she visits the nearest CSC (Common Service Centre) with her documents to finalize her submission.

---

## Contributing

We welcome contributions to bring this solution to every corner of India. Please follow these steps:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

### Development Guidelines
- Strictly follow the [Flutter style guide](https://dart.dev/guides/language/effective-dart/style).
- Maintain clean, documented, and modular architecture.
- Ensure government-style design consistency in all UI additions.

---

## Impact Metrics

- **800 million** rural Indians actively underserved.
- **8-12** average schemes available per eligible citizen.
- **₹40,000-₹80,000** average unclaimed benefit per family, per year.
- **90 seconds** average time taken to discover eligible schemes.
- **50+** key government schemes mapped directly into the database.
- **10+** Indian languages natively supported.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Built for INDIA**

**Your Right. Delivered.**

# A d h i k a r

</div>