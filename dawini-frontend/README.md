# Dawini Frontend

Flutter app for the Dawini healthcare platform.

## Setup

1. Install Flutter dependencies.
2. Provide runtime config with dart defines:

```bash
flutter run \
	--dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1 \
	--dart-define=SUPABASE_URL=your-supabase-url \
	--dart-define=SUPABASE_ANON_KEY=your-supabase-anon-key
```

3. Ensure assets are present in `assets/lang/`.

## Localization

- French: `assets/lang/fr.json`
- English: `assets/lang/en.json`

## Backend contract

- Auth sync: `POST /api/v1/auth/sync-profile`
- Patient medicine search: `GET /api/v1/patients/medicines/search`
- Medicine details: `GET /api/v1/patients/medicines/{medicine_id}`

## Notes

- The app supports patient, pharmacy, and admin routing.
- Supabase session state controls splash routing and profile language selection.
# test_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
