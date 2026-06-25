# Dawini Frontend V1

Ce dossier contient la partie frontend Flutter statique qui reprend les écrans de tes maquettes :

- Splash Screen
- Onboarding
- Login
- Register
- Role Selection
- Patient Registration
- User Home
- Medicine Search
- Search Results
- Medicine Details
- My Requests
- User Alerts
- User Profile
- Pharmacy Registration
- Pharmacy Details
- Confirmation Request
- Pharmacy Dashboard
- Inventory Management
- Add/Edit Stock
- Pharmacy Requests
- Admin Dashboard

## Installation

1. Crée un projet Flutter :

```bash
flutter create dawini
```

2. Remplace le `pubspec.yaml`, le dossier `lib/` et le dossier `assets/` par ceux fournis ici.

3. Lance :

```bash
flutter pub get
flutter run
```

## Important

Cette version est la couche UI. Les données sont encore statiques. Après validation de l'UI, on branche :

- Supabase Auth
- Supabase tables
- Firebase notifications
- n8n automations
