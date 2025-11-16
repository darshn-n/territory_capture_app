# Territory Capture App

## Features
- Google Sign-In (Firebase Auth)
- Live GPS polyline → auto-close polygon
- Save to Firestore (user-scoped)
- List + Detail with real-time updates
- Location permission + denied → open settings
- Clean Architecture + GetX

## Setup
1. Add your `google-services.json` (Android) / `GoogleService-Info.plist` (iOS)
2. Replace `YOUR_GOOGLE_MAPS_API_KEY` in `AndroidManifest.xml`
3. Run:
```bash
flutter pub get
flutter run