import 'package:google_generative_ai/google_generative_ai.dart';
import '../utils/constants.dart';

/// 🤖 AiRecipeService
///
/// Uses Google Gemini to generate creative recipes from a list of ingredients.
///
/// Prerequisites:
/// 1. Add your Gemini API key in [AppConstants.geminiApiKey]
/// 2. Ensure internet access
///
/// Usage:
/// ```dart
/// final service = AiRecipeService();
/// final result = await service.generateRecipe(['chicken', 'lemon', 'thyme']);
/// if (result.isSuccess) {
///   print(result.recipe!.name);
/// }
/// ```
class AiRecipeService {
  GenerativeModel? _model;

  /// Lazily initialise the model so we don't crash if the key isn't set yet.
  GenerativeModel get _generativeModel {
    _model ??= GenerativeModel(
      // TODO: Set your Gemini API key in lib/utils/constants.dart
      apiKey: AppConstants.geminiApiKey,
      model: AppConstants.geminiModel,
      generationConfig: GenerationConfig(
        temperature: 0.85,
        maxOutputTokens: 1024,
      ),
      systemInstruction: Content.system(
        'You are a warm, creative culinary assistant for the Recipezz app. '
        'You help home cooks make delicious meals with whatever ingredients they have. '
        'Your tone is friendly, encouraging, and cozy — like a knowledgeable friend in the kitchen. '
        'Always format your responses exactly as instructed.',
      ),
    );
    return _model!;
  }

  // ---------------------------------------------------------------------------
  // 🪄 Generate recipe from ingredients
  // ---------------------------------------------------------------------------

  /// Generate a recipe from a list of ingredient strings.
  ///
  /// Returns an [AiRecipeResult] containing either a parsed [AiGeneratedRecipe]
  /// or an error message.
  Future<AiRecipeResult> generateRecipe(List<String> ingredients) async {
    if (ingredients.isEmpty) {
      return AiRecipeResult.error('Please provide at least one ingredient!');
    }

    if (AppConstants.geminiApiKey == 'YOUR_GEMINI_API_KEY') {
      return AiRecipeResult.error(
        '🔑 Gemini API key not set.\n'
        'Add your key to lib/utils/constants.dart → AppConstants.geminiApiKey',
      );
    }

    try {
      final prompt = AppConstants.aiMagicPromptTemplate.replaceFirst(
        '{ingredients}',
        ingredients.join(', '),
      );

      final response = await _generativeModel.generateContent(
        [Content.text(prompt)],
      );

      final text = response.text;
      if (text == null || text.isEmpty) {
        return AiRecipeResult.error(AppConstants.errorGeneric);
      }

      final recipe = _parseResponse(text, ingredients);
      return AiRecipeResult.success(recipe);
    } on GenerativeAIException catch (e) {
      return AiRecipeResult.error('AI Error: ${e.message}');
    } catch (e) {
      return AiRecipeResult.error(_mapError(e));
    }
  }

  // ---------------------------------------------------------------------------
  // 💡 Suggest meal ideas (lightweight, no full recipe)
  // ---------------------------------------------------------------------------

  /// Quick ingredient → meal name suggestions (for search autocomplete)
  Future<AiRecipeResult> suggestMealIdeas(List<String> ingredients) async {
    if (AppConstants.geminiApiKey == 'YOUR_GEMINI_API_KEY') {
      return AiRecipeResult.error('Gemini API key not configured.');
    }

    try {
      final prompt =
          'Given these ingredients: ${ingredients.join(', ')}, '
          'suggest 5 meal names I could make. '
          'Reply with ONLY a numbered list of meal names, nothing else.';

      final response = await _generativeModel.generateContent(
        [Content.text(prompt)],
      );

      return AiRecipeResult.rawText(response.text ?? '');
    } catch (e) {
      return AiRecipeResult.error(_mapError(e));
    }
  }

  // ---------------------------------------------------------------------------
  // 🔧 Private helpers
  // ---------------------------------------------------------------------------

  AiGeneratedRecipe _parseResponse(String text, List<String> ingredients) {
    String name = 'AI Recipe';
    String description = '';
    final recipeIngredients = <String>[];
    final instructions = <String>[];
    String tips = '';

    // Very simple line-by-line parser
    String? currentSection;

    for (final line in text.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith('NAME:')) {
        name = trimmed.replaceFirst('NAME:', '').trim();
      } else if (trimmed.startsWith('DESCRIPTION:')) {
        description = trimmed.replaceFirst('DESCRIPTION:', '').trim();
      } else if (trimmed.startsWith('INGREDIENTS:')) {
        currentSection = 'ingredients';
      } else if (trimmed.startsWith('INSTRUCTIONS:')) {
        currentSection = 'instructions';
      } else if (trimmed.startsWith('TIPS:')) {
        currentSection = 'tips';
        tips = trimmed.replaceFirst('TIPS:', '').trim();
      } else {
        switch (currentSection) {
          case 'ingredients':
            recipeIngredients.add(trimmed.replaceFirst(RegExp(r'^[-•*]\s*'), ''));
          case 'instructions':
            instructions.add(trimmed.replaceFirst(RegExp(r'^\d+\.\s*'), ''));
          case 'tips':
            tips += ' $trimmed';
        }
      }
    }

    return AiGeneratedRecipe(
      name: name,
      description: description,
      ingredients: recipeIngredients.isNotEmpty ? recipeIngredients : ingredients,
      instructions: instructions,
      tips: tips.trim(),
      rawIngredientInput: ingredients,
    );
  }

  String _mapError(Object e) {
    final msg = e.toString();
    if (msg.contains('SocketException') || msg.contains('Failed host lookup')) {
      return AppConstants.errorNoInternet;
    }
    if (msg.contains('API_KEY_INVALID')) {
      return '🔑 Invalid Gemini API key. Check constants.dart.';
    }
    return AppConstants.errorGeneric;
  }
}

// ---------------------------------------------------------------------------
// 📦 Result wrapper
// ---------------------------------------------------------------------------

class AiRecipeResult {
  final AiGeneratedRecipe? recipe;
  final String? rawText;
  final String? errorMessage;

  const AiRecipeResult._({this.recipe, this.rawText, this.errorMessage});

  factory AiRecipeResult.success(AiGeneratedRecipe recipe) =>
      AiRecipeResult._(recipe: recipe);

  factory AiRecipeResult.rawText(String text) =>
      AiRecipeResult._(rawText: text);

  factory AiRecipeResult.error(String message) =>
      AiRecipeResult._(errorMessage: message);

  bool get isSuccess => errorMessage == null;
  bool get isError => errorMessage != null;
}

// ---------------------------------------------------------------------------
// 📦 AI-generated recipe model
// ---------------------------------------------------------------------------

class AiGeneratedRecipe {
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final String tips;
  final List<String> rawIngredientInput;

  const AiGeneratedRecipe({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.tips,
    required this.rawIngredientInput,
  });
}
