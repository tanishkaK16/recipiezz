# 🚀 Recipezz — Quick Start

## 1. Install Flutter (if not already installed)

```bash
# macOS (recommended via official installer)
# Download from: https://docs.flutter.dev/get-started/install/macos

# Or via Homebrew:
brew install flutter

# Verify installation
flutter doctor
```

## 2. Install dependencies

```bash
cd recipiezz
flutter pub get
```

## 3. Configure your API keys

**Supabase** — in `lib/main.dart`:
```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',        ← replace this
  anonKey: 'YOUR_SUPABASE_ANON_KEY',  ← replace this
);
```

**Gemini AI** — in `lib/utils/constants.dart`:
```dart
static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';  ← replace this
```

## 4. Run the app

```bash
flutter run
```

## 5. Next features to build

- `lib/screens/auth/` — Login & Sign Up with Supabase
- `lib/screens/discover/` — Browse + search recipes
- `lib/screens/ai_magic/` — Gemini ingredient → recipe generator
- `lib/screens/my_book/` — Saved recipes from Supabase
- `lib/screens/recipe_detail/` — Full recipe view with YouTube

## Build runner (for Riverpod code generation)

```bash
dart run build_runner build --delete-conflicting-outputs
# or for watch mode during development:
dart run build_runner watch
```
