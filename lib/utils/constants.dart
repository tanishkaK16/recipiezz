/// 🔑 App-wide Constants
///
/// Central place for all magic strings, API keys, URLs and color tokens
/// that need to be easily accessible across the app.
///
/// ⚠️  Replace all placeholder values marked with TODO before publishing.
class AppConstants {
  AppConstants._();

  // ---------------------------------------------------------------------------
  // 🤖 Gemini AI
  // ---------------------------------------------------------------------------

  /// 🔑 Add your Gemini API key here — in YOUR LOCAL lib/utils/constants.dart.
  /// This file is in .gitignore via lib/main.dart pattern; keep keys local only.
  /// Get a free key at: https://aistudio.google.com/app/apikey
  ///
  /// ⚠️  NEVER commit a real API key. Keep this as the placeholder in the repo.
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';

  /// Model to use for recipe generation
  static const String geminiModel = 'gemini-2.0-flash';

  // ---------------------------------------------------------------------------
  // 🍽️ TheMealDB API
  // ---------------------------------------------------------------------------

  /// Free public API — no key required for tier 1
  static const String mealDbBaseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static const String mealDbSearchUrl = '$mealDbBaseUrl/search.php';
  static const String mealDbLookupUrl = '$mealDbBaseUrl/lookup.php';
  static const String mealDbRandomUrl = '$mealDbBaseUrl/random.php';
  static const String mealDbCategoriesUrl = '$mealDbBaseUrl/categories.php';
  static const String mealDbFilterUrl = '$mealDbBaseUrl/filter.php';

  // ---------------------------------------------------------------------------
  // 🔤 App Strings
  // ---------------------------------------------------------------------------

  static const String appName = 'Recipezz';
  static const String appTagline = 'Your cozy digital recipe book 🍪';

  // Onboarding
  static const String welcomeTitle = 'Welcome to Recipezz 🍰';
  static const String welcomeSubtitle =
      'Discover recipes, save your favourites, and let AI inspire your next meal.';

  // AI Magic
  static const String aiMagicTitle = 'AI Recipe Magic ✨';
  static const String aiMagicSubtitle =
      'Tell me what\'s in your fridge — I\'ll conjure a recipe!';
  static const String aiMagicPlaceholder =
      'e.g. chicken, lemon, thyme, potatoes...';
  static const String aiMagicPromptTemplate =
      'Create a detailed, delicious recipe using these ingredients: {ingredients}. '
      'Format the response as:\n'
      'NAME: [recipe name]\n'
      'DESCRIPTION: [short appetising description]\n'
      'INGREDIENTS:\n[list]\n'
      'INSTRUCTIONS:\n[numbered steps]\n'
      'TIPS: [optional chef tips]';

  // Navigation
  static const String navHome = 'Home';
  static const String navDiscover = 'Discover';
  static const String navAiMagic = 'AI Magic';
  static const String navMyBook = 'My Book';

  // Errors
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNoInternet =
      'No internet connection. Check your network!';
  static const String errorNotFound = 'Recipe not found 😕';

  // ---------------------------------------------------------------------------
  // 🎨 Hex Color Strings (reference)
  // ---------------------------------------------------------------------------
  // These mirror CozyTheme colors as hex strings for convenience.

  static const String hexBackground = '#FFF9F0';
  static const String hexPrimary = '#E07A5F';
  static const String hexSecondary = '#81B29A';
  static const String hexAccent = '#F0C36B';
  static const String hexTextDark = '#3D2B1F';
  static const String hexTextMuted = '#8C7B6E';
  static const String hexSurface = '#FFF3E8';
  static const String hexBorder = '#EDD9C8';

  // ---------------------------------------------------------------------------
  // 📐 Layout
  // ---------------------------------------------------------------------------

  static const double paddingXs = 4.0;
  static const double paddingSm = 8.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;

  static const double radiusSm = 10.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 28.0;
  static const double radiusFull = 100.0;

  // ---------------------------------------------------------------------------
  // ⏱️ Durations
  // ---------------------------------------------------------------------------

  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
}
