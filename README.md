# 🍰 Recipezz — Your Cozy Digital Recipe Book

A warm, illustrated Flutter app to discover, save, and generate AI-powered recipes — wrapped in a cozy cottagecore kitchen aesthetic.

---

## 🏡 Project Structure

```
lib/
├── main.dart                   # App entry point, Supabase + GoRouter setup
├── models/
│   └── recipe.dart             # Core Recipe data model
├── services/
│   ├── meal_db_service.dart    # TheMealDB API integration
│   └── ai_recipe_service.dart  # Gemini AI recipe generation
├── screens/
│   ├── auth/                   # Login / Sign Up screens
│   ├── home/                   # Main app shell & dashboard
│   ├── discover/               # Browse & search recipes
│   ├── ai_magic/               # AI recipe generator
│   ├── my_book/                # User's saved recipes
│   └── recipe_detail/          # Full recipe view
├── widgets/
│   ├── cozy_card.dart          # Reusable recipe card component
│   └── cute_button.dart        # Branded CTA buttons
├── providers/                  # Riverpod providers
├── utils/
│   └── constants.dart          # Colors, strings, API URLs
└── theme/
    └── cozy_theme.dart         # Full Material 3 theme definition
```

---

## 🚀 Getting Started

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Configure Supabase
In `lib/main.dart`, replace:
```dart
supabaseUrl: 'YOUR_SUPABASE_URL',
supabaseAnonKey: 'YOUR_SUPABASE_ANON_KEY',
```
with your actual Supabase project credentials from [supabase.com](https://supabase.com).

### 3. Configure Gemini AI
In `lib/utils/constants.dart`, replace:
```dart
static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
```
with your API key from [Google AI Studio](https://aistudio.google.com).

### 4. Run the app
```bash
flutter run
```

---

## 🛠️ Next Steps

- [ ] Build Auth screens (Login / Signup with Supabase)
- [ ] Implement TheMealDB fetch in `meal_db_service.dart`
- [ ] Build the Discover screen with search & categories
- [ ] Wire up Gemini AI in `ai_recipe_service.dart`
- [ ] Build My Book (saved recipes with Supabase)
- [ ] Add Lottie animations for loading states
- [ ] Set up Riverpod providers for state management

---

## 🎨 Design System

| Token       | Value       | Usage              |
|-------------|-------------|--------------------|
| Primary     | `#E07A5F`   | Buttons, accents   |
| Secondary   | `#81B29A`   | Tags, chips        |
| Accent      | `#F0C36B`   | Highlights, stars  |
| Background  | `#FFF9F0`   | App background     |
| Heading Font| Playfair Display | Titles        |
| Body Font   | Nunito      | All body text      |

---

Made with 🍪 and Flutter.
