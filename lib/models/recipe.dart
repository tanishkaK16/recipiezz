/// 🍽️ Recipe Model
///
/// Represents a single recipe in the Recipezz app.
/// Can be sourced from TheMealDB, user-created, or AI-generated.
class Recipe {
  final String id;
  final String name;
  final String? image;
  final String? category;
  final String? area;
  final String? description;
  final List<String> ingredients;
  final List<String> measures;
  final List<String> instructions;
  final String? youtubeUrl;
  final String? sourceUrl;
  final RecipeSource source;
  final bool isFavourite;
  final DateTime? createdAt;
  final String? userId; // Supabase user ID (for saved recipes)

  const Recipe({
    required this.id,
    required this.name,
    this.image,
    this.category,
    this.area,
    this.description,
    this.ingredients = const [],
    this.measures = const [],
    this.instructions = const [],
    this.youtubeUrl,
    this.sourceUrl,
    this.source = RecipeSource.mealDb,
    this.isFavourite = false,
    this.createdAt,
    this.userId,
  });

  // ---------------------------------------------------------------------------
  // 🔄 Serialisation — TheMealDB API format
  // ---------------------------------------------------------------------------

  factory Recipe.fromMealDbJson(Map<String, dynamic> json) {
    // MealDB stores ingredients/measures as ingredient1..20, measure1..20
    final ingredients = <String>[];
    final measures = <String>[];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'] as String?;
      final measure = json['strMeasure$i'] as String?;
      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredients.add(ingredient.trim());
        measures.add(measure?.trim() ?? '');
      }
    }

    // Split instructions into steps
    final rawInstructions = json['strInstructions'] as String? ?? '';
    final steps = rawInstructions
        .split('\r\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    return Recipe(
      id: json['idMeal'] as String? ?? '',
      name: json['strMeal'] as String? ?? 'Unknown Recipe',
      image: json['strMealThumb'] as String?,
      category: json['strCategory'] as String?,
      area: json['strArea'] as String?,
      ingredients: ingredients,
      measures: measures,
      instructions: steps,
      youtubeUrl: json['strYoutube'] as String?,
      sourceUrl: json['strSource'] as String?,
      source: RecipeSource.mealDb,
    );
  }

  // ---------------------------------------------------------------------------
  // 🔄 Serialisation — Supabase / JSON
  // ---------------------------------------------------------------------------

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
      category: json['category'] as String?,
      area: json['area'] as String?,
      description: json['description'] as String?,
      ingredients: List<String>.from(json['ingredients'] as List? ?? []),
      measures: List<String>.from(json['measures'] as List? ?? []),
      instructions: List<String>.from(json['instructions'] as List? ?? []),
      youtubeUrl: json['youtube_url'] as String?,
      sourceUrl: json['source_url'] as String?,
      source: RecipeSource.values.firstWhere(
        (e) => e.name == (json['source'] as String?),
        orElse: () => RecipeSource.mealDb,
      ),
      isFavourite: json['is_favourite'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      userId: json['user_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'category': category,
      'area': area,
      'description': description,
      'ingredients': ingredients,
      'measures': measures,
      'instructions': instructions,
      'youtube_url': youtubeUrl,
      'source_url': sourceUrl,
      'source': source.name,
      'is_favourite': isFavourite,
      'created_at': createdAt?.toIso8601String(),
      'user_id': userId,
    };
  }

  // ---------------------------------------------------------------------------
  // 🛠️ Helpers
  // ---------------------------------------------------------------------------

  /// Returns ingredients paired with their measures
  List<({String ingredient, String measure})> get ingredientPairs {
    return List.generate(
      ingredients.length,
      (i) => (
        ingredient: ingredients[i],
        measure: i < measures.length ? measures[i] : '',
      ),
    );
  }

  /// Returns a YouTube video ID from the full URL (if available)
  String? get youtubeVideoId {
    if (youtubeUrl == null) return null;
    final uri = Uri.tryParse(youtubeUrl!);
    return uri?.queryParameters['v'];
  }

  Recipe copyWith({
    String? id,
    String? name,
    String? image,
    String? category,
    String? area,
    String? description,
    List<String>? ingredients,
    List<String>? measures,
    List<String>? instructions,
    String? youtubeUrl,
    String? sourceUrl,
    RecipeSource? source,
    bool? isFavourite,
    DateTime? createdAt,
    String? userId,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      category: category ?? this.category,
      area: area ?? this.area,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      measures: measures ?? this.measures,
      instructions: instructions ?? this.instructions,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      source: source ?? this.source,
      isFavourite: isFavourite ?? this.isFavourite,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Recipe && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Recipe(id: $id, name: $name, source: $source)';
}

// ---------------------------------------------------------------------------
// 📦 Enums
// ---------------------------------------------------------------------------

/// Where a recipe came from
enum RecipeSource {
  /// TheMealDB public API
  mealDb,

  /// Generated by Gemini AI
  aiGenerated,

  /// Created by the user manually
  userCreated,
}
