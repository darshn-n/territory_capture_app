# Territory Capture App

A real-world territory capture mobile application built with Flutter + Firebase.

## Overview
Users sign in with Google, walk around an area while the app records high-accuracy GPS points every 5 metres, draws a live polyline, and on Finish automatically closes the polygon, calculates distance & approximate area, and saves everything to Firestore.

## Features Implemented
- Google Sign-In (Firebase Auth)
- Full-screen Google Maps centered on user location
- Start / Pause / Resume / Finish / Discard controls
- GPS sampling with 5 m distance filter
- Live polyline drawing
- Auto-close polygon on Finish
- Real-time distance & area calculation
- Save territory + metadata to Firestore
- Real-time territory list with pull-to-refresh
- Detail view with filled polygon, original polyline, auto-fit bounds, full metadata
- Location permission handling with “open settings” screen
- Clean Architecture + GetX
- Material 3 design with professional polish

## Technical Stack
- Flutter 3.24+ (stable)
- Firebase Auth, Firestore
- google_maps_flutter
- geolocator + permission_handler
- get: ^4.6.6
- dartz for Either<Failure, Success>

## Architecture
Strict Clean Architecture (3 layers + core):
```
lib/
├── core/              → failures, exceptions, utils, constants
├── data/              → models, datasources, repositories
├── domain/            → entities, repositories (abstract), usecases
├── presentation/      → pages, controllers, widgets, bindings
├── routes/            → app_routes.dart
├── injection.dart     → GetX dependency injection (fenix: true for proper lifecycle)
└── main.
```

## Folder Architecture
```
lib/
├── core/
│   ├── error/         → failures.dart, exceptions.dart
│   └── utils/         → constants.dart, location_helper.dart, area_calculator.dart
├── data/
│   ├── datasources/   → territory_remote_datasource.dart
│   ├── models/        → territory_model.dart
│   └── repositories/  → territory_repository_impl.dart
├── domain/
│   ├── entities/      → territory.dart, lat_lng_timestamp.dart
│   ├── repositories/  → abstract_territory_repository.dart
│   └── usecases/      → save_territory.dart, get_user_territories.dart, get_territory.dart
├── presentation/
│   ├── bindings/      → auth, capture, list, detail
│   ├── controllers/   → auth_controller, capture_controller, territory_list_controller, territory_detail_controller
│   ├── pages/         → splash, login, capture, list, detail, permission_denied
│   └── widgets/       → control_button, territory_list_tile
├── routes/
│   └── app_routes.dart
├── injection.dart
└── main.dart
```


## Firebase Setup
1. Create Firebase project
2. Enable Authentication → Google Sign-In
3. Enable Firestore
4. Add `google-services.json` (Android) / `GoogleService-Info.plist` (iOS)
5. Paste these exact security rules:

```rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /territories/{territoryId} {
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow read, update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }
  }
}
```
# Run
```
flutter pub get
flutter run
```

# Build release apk
```
flutter build apk --release
```