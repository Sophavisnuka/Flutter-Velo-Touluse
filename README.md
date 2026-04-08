# velo_toulouse

Velo Toulouse is a Flutter app that displays bike stations on a map and reads station data from Firebase.

## Prerequisites

Install these tools before running the project:

- Flutter SDK (stable)
- Dart SDK (included with Flutter)
- Firebase CLI
- FlutterFire CLI
- Android Studio and/or Xcode (for mobile builds)

### Install Firebase CLI

```bash
npm install -g firebase-tools
firebase login
```

### Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

If needed, add pub global binaries to your PATH:

```bash
flutter pub global list
```

## Project Setup

From the project root:

```bash
flutter pub get
```

Create `.env` at the project root and add your Mapbox token:

```env
MAPBOX_ACCESS_TOKEN=your_mapbox_token_here
```

## Firebase Setup

This project initializes Firebase in [lib/main.dart](lib/main.dart#L23) using [lib/firebase_options.dart](lib/firebase_options.dart#L1).

### 1. Create or Select Firebase Project

```bash
firebase login
firebase projects:list
```

Use your existing Firebase project or create a new one in Firebase Console.

### 2. Configure FlutterFire for this app

Run this in the project root:

```bash
flutterfire configure
```

This command:

- Registers your Flutter platforms in Firebase
- Generates/updates [lib/firebase_options.dart](lib/firebase_options.dart#L1)
- Helps map platform app IDs and bundle IDs

If you want to target specific platforms, use:

```bash
flutterfire configure --platforms=android,ios,web,macos,windows
```

### 3. Android Firebase Files

Make sure Android config exists at:

- [android/app/google-services.json](android/app/google-services.json)

This project already applies Google Services plugin in [android/app/build.gradle.kts](android/app/build.gradle.kts#L1).

### 4. iOS Firebase Files

Add iOS config file:

- `GoogleService-Info.plist` -> place it in `ios/Runner/`

Then run:

```bash
cd ios
pod install
cd ..
```

### 5. Enable Required Firebase Products

In Firebase Console, enable products your app needs (for this repo, Firestore is required):

- Cloud Firestore
- Firebase Authentication (if you plan to use auth flows)

## Run the App

```bash
flutter run
```

If Firebase setup is correct, the app should pass [lib/main.dart](lib/main.dart#L23) initialization and load station data.

## Troubleshooting

- Missing Mapbox token: ensure `.env` contains `MAPBOX_ACCESS_TOKEN`.
- Firebase init error: rerun `flutterfire configure` and verify [lib/firebase_options.dart](lib/firebase_options.dart#L1).
- Android build issues: confirm [android/app/google-services.json](android/app/google-services.json) matches your Firebase Android app ID.
- iOS build issues: confirm `GoogleService-Info.plist` exists in `ios/Runner/` and run `pod install`.
