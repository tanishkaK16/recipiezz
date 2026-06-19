// lib/providers/ai_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_recipe_service.dart';

// ---------------------------------------------------------------------------
// 🤖 AI Recipe Providers
// ---------------------------------------------------------------------------

/// Provides a singleton [AiRecipeService]
final aiRecipeServiceProvider = Provider<AiRecipeService>((ref) {
  return AiRecipeService();
});

/// Holds the current list of ingredients for AI generation
final aiIngredientsProvider =
    StateNotifierProvider<IngredientsNotifier, List<String>>(
  (ref) => IngredientsNotifier(),
);

class IngredientsNotifier extends StateNotifier<List<String>> {
  IngredientsNotifier() : super([]);

  void add(String ingredient) {
    final trimmed = ingredient.trim();
    if (trimmed.isNotEmpty && !state.contains(trimmed)) {
      state = [...state, trimmed];
    }
  }

  void remove(String ingredient) {
    state = state.where((i) => i != ingredient).toList();
  }

  void clear() => state = [];
}

/// Async state for AI recipe generation
final aiGenerationProvider =
    FutureProvider.autoDispose<AiGeneratedRecipe?>((ref) async {
  final ingredients = ref.watch(aiIngredientsProvider);
  if (ingredients.isEmpty) return null;

  final service = ref.read(aiRecipeServiceProvider);
  final result = await service.generateRecipe(ingredients);

  if (result.isError) throw Exception(result.errorMessage);
  return result.recipe;
});
