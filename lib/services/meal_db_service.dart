import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';
import '../utils/constants.dart';

/// 🍽️ MealDbService
///
/// Communicates with TheMealDB free public API (v1).
/// API documentation: https://www.themealdb.com/api.php
///
/// All methods return typed results and never throw — errors are surfaced
/// via [MealDbResult] which wraps either data or an error message.
class MealDbService {
  final http.Client _client;

  MealDbService({http.Client? client}) : _client = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // 🔍 Search
  // ---------------------------------------------------------------------------

  /// Search recipes by name (e.g. "chicken", "pasta")
  Future<MealDbResult<List<Recipe>>> searchByName(String query) async {
    return _fetchRecipes(
      Uri.parse('${AppConstants.mealDbSearchUrl}?s=${Uri.encodeComponent(query)}'),
    );
  }

  /// Search recipes by first letter
  Future<MealDbResult<List<Recipe>>> searchByFirstLetter(String letter) async {
    assert(letter.length == 1, 'letter must be a single character');
    return _fetchRecipes(
      Uri.parse('${AppConstants.mealDbSearchUrl}?f=$letter'),
    );
  }

  // ---------------------------------------------------------------------------
  // 🔎 Lookup
  // ---------------------------------------------------------------------------

  /// Look up a single recipe by its MealDB ID
  Future<MealDbResult<Recipe>> lookupById(String id) async {
    try {
      final uri = Uri.parse('${AppConstants.mealDbLookupUrl}?i=$id');
      final response = await _client.get(uri);
      _checkStatus(response);

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final meals = body['meals'] as List?;

      if (meals == null || meals.isEmpty) {
        return MealDbResult.error(AppConstants.errorNotFound);
      }

      return MealDbResult.success(
        Recipe.fromMealDbJson(meals.first as Map<String, dynamic>),
      );
    } catch (e) {
      return MealDbResult.error(_mapError(e));
    }
  }

  /// Fetch a single random recipe
  Future<MealDbResult<Recipe>> fetchRandom() async {
    try {
      final response = await _client
          .get(Uri.parse(AppConstants.mealDbRandomUrl));
      _checkStatus(response);

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final meals = body['meals'] as List?;

      if (meals == null || meals.isEmpty) {
        return MealDbResult.error(AppConstants.errorNotFound);
      }

      return MealDbResult.success(
        Recipe.fromMealDbJson(meals.first as Map<String, dynamic>),
      );
    } catch (e) {
      return MealDbResult.error(_mapError(e));
    }
  }

  // ---------------------------------------------------------------------------
  // 📂 Categories & Filters
  // ---------------------------------------------------------------------------

  /// Fetch all available meal categories
  Future<MealDbResult<List<MealCategory>>> fetchCategories() async {
    try {
      final response = await _client
          .get(Uri.parse(AppConstants.mealDbCategoriesUrl));
      _checkStatus(response);

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final cats = body['categories'] as List? ?? [];

      final categories = cats
          .cast<Map<String, dynamic>>()
          .map(MealCategory.fromJson)
          .toList();

      return MealDbResult.success(categories);
    } catch (e) {
      return MealDbResult.error(_mapError(e));
    }
  }

  /// Filter recipes by category name (returns thumbnail list)
  Future<MealDbResult<List<Recipe>>> filterByCategory(String category) async {
    return _fetchRecipes(
      Uri.parse(
          '${AppConstants.mealDbFilterUrl}?c=${Uri.encodeComponent(category)}'),
      isThumbnailList: true,
    );
  }

  /// Filter recipes by area / cuisine (e.g. "Italian", "Japanese")
  Future<MealDbResult<List<Recipe>>> filterByArea(String area) async {
    return _fetchRecipes(
      Uri.parse(
          '${AppConstants.mealDbFilterUrl}?a=${Uri.encodeComponent(area)}'),
      isThumbnailList: true,
    );
  }

  // ---------------------------------------------------------------------------
  // 🔧 Private helpers
  // ---------------------------------------------------------------------------

  Future<MealDbResult<List<Recipe>>> _fetchRecipes(
    Uri uri, {
    bool isThumbnailList = false,
  }) async {
    try {
      final response = await _client.get(uri);
      _checkStatus(response);

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final meals = body['meals'] as List?;

      if (meals == null) return MealDbResult.success([]);

      final recipes = meals
          .cast<Map<String, dynamic>>()
          .map(Recipe.fromMealDbJson)
          .toList();

      return MealDbResult.success(recipes);
    } catch (e) {
      return MealDbResult.error(_mapError(e));
    }
  }

  void _checkStatus(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  String _mapError(Object e) {
    if (e.toString().contains('SocketException') ||
        e.toString().contains('Failed host lookup')) {
      return AppConstants.errorNoInternet;
    }
    return AppConstants.errorGeneric;
  }
}

// ---------------------------------------------------------------------------
// 📦 Result wrapper
// ---------------------------------------------------------------------------

class MealDbResult<T> {
  final T? data;
  final String? errorMessage;

  const MealDbResult._({this.data, this.errorMessage});

  factory MealDbResult.success(T data) => MealDbResult._(data: data);
  factory MealDbResult.error(String message) =>
      MealDbResult._(errorMessage: message);

  bool get isSuccess => errorMessage == null;
  bool get isError => errorMessage != null;
}

// ---------------------------------------------------------------------------
// 📦 Category model
// ---------------------------------------------------------------------------

class MealCategory {
  final String id;
  final String name;
  final String? thumbnail;
  final String? description;

  const MealCategory({
    required this.id,
    required this.name,
    this.thumbnail,
    this.description,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) => MealCategory(
        id: json['idCategory'] as String? ?? '',
        name: json['strCategory'] as String? ?? '',
        thumbnail: json['strCategoryThumb'] as String?,
        description: json['strCategoryDescription'] as String?,
      );
}
