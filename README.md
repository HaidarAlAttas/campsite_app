# CampsiteMY 🏕️

Flutter + Firebase + BLoC campsite booking app for Malaysia.

---

## ✅ How to Run (3 Steps)

### Step 1 — Firebase Setup
1. Go to https://console.firebase.google.com
2. Create project → enable **Authentication** (Email/Password + Google) + **Cloud Firestore**
3. Add an Android app with package name: `com.example.campsite_app`
4. Download `google-services.json` → place it in `android/app/`

### Step 2 — Generate firebase_options.dart
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
This replaces the placeholder `lib/firebase_options.dart` with real values.

### Step 3 — Run
```bash
flutter pub get
flutter run
```

---

## Seed Firestore Data
Open `seed_firebase.js` — paste the campsite data into Firestore manually,
or run via Node.js:
```bash
npm install firebase-admin
node seed_firebase.js
```

---

## Package Versions (pubspec.yaml)
All packages updated to latest stable (June 2025):
- firebase_core: ^3.13.1
- firebase_auth: ^5.5.4
- cloud_firestore: ^5.6.6
- flutter_bloc: ^9.1.1
- go_router: ^15.1.2

## Android Requirements
- minSdk: 23 (Android 6.0+)
- compileSdk: 35
- Core library desugaring enabled (for table_calendar date support)
