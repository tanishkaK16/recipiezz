import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/meal_db_service.dart';
import '../models/recipe.dart';

// ---------------------------------------------------------------------------
// 🔌 Service Providers
// ---------------------------------------------------------------------------

/// Provides a singleton [MealDbService] instance
final mealDbServiceProvider = Provider<MealDbService>((ref) {
  return MealDbService();
});

// ---------------------------------------------------------------------------
// 🔍 Recipe Search Provider
// ---------------------------------------------------------------------------

/// State for the search query string
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Async provider that fetches recipes matching the current search query.
/// Returns an empty list when the query is blank.
final searchResultsProvider =
    FutureProvider.autoDispose<List<Recipe>>((ref) async {
  final query = ref.watch(searchQueryProvider);

  if (query.trim().isEmpty) return [];

  final service = ref.read(mealDbServiceProvider);
  final result = await service.searchByName(query.trim());

  if (result.isError) {
    throw Exception(result.errorMessage);
  }

  return result.data ?? [];
});

// ---------------------------------------------------------------------------
// 📂 Categories Provider
// ---------------------------------------------------------------------------

/// Async provider for all MealDB categories
final categoriesProvider =
    FutureProvider.autoDispose<List<MealCategory>>((ref) async {
  final service = ref.read(mealDbServiceProvider);
  final result = await service.fetchCategories();

  if (result.isError) throw Exception(result.errorMessage);
  return result.data ?? [];
});

// ---------------------------------------------------------------------------
// 🎲 Random Recipe Provider
// ---------------------------------------------------------------------------

/// Fetches a single random recipe — invalidate to refresh
final randomRecipeProvider = FutureProvider<Recipe>((ref) async {
  final service = ref.read(mealDbServiceProvider);
  final result = await service.fetchRandom();

  if (result.isError) throw Exception(result.errorMessage);
  return result.data!;
});

// ---------------------------------------------------------------------------
// 🔎 Selected Category Provider
// ---------------------------------------------------------------------------

/// The currently selected category filter (null = all)
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

/// Recipes filtered by the selected category
final filteredByCategory =
    FutureProvider.autoDispose<List<Recipe>>((ref) async {
  final category = ref.watch(selectedCategoryProvider);
  if (category == null) return [];

  final service = ref.read(mealDbServiceProvider);
  final result = await service.filterByCategory(category);

  if (result.isError) throw Exception(result.errorMessage);
  return result.data ?? [];
});
