import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/recipe.dart';

// ---------------------------------------------------------------------------
// 🔐 Auth Providers
// ---------------------------------------------------------------------------

/// Current Supabase auth session — null if logged out
final authSessionProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

/// Current user — null if not authenticated
final currentUserProvider = Provider<User?>((ref) {
  return Supabase.instance.client.auth.currentUser;
});

// ---------------------------------------------------------------------------
// 📖 Saved Recipes (My Book) Providers
// ---------------------------------------------------------------------------

/// Provider for all saved recipes for the current user.
///
/// TODO: Implement once you have created the `saved_recipes` table in Supabase.
/// Suggested schema:
/// ```sql
/// create table saved_recipes (
///   id uuid primary key default uuid_generate_v4(),
///   user_id uuid references auth.users(id) on delete cascade,
///   recipe_id text not null,
///   recipe_name text not null,
///   recipe_image text,
///   recipe_data jsonb not null,
///   created_at timestamptz default now()
/// );
/// alter table saved_recipes enable row level security;
/// create policy "Users can manage their own saved recipes"
///   on saved_recipes for all using (auth.uid() = user_id);
/// ```
final savedRecipesProvider =
    FutureProvider.autoDispose<List<Recipe>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  // TODO: Uncomment and implement when Supabase table is ready
  // final response = await Supabase.instance.client
  //     .from('saved_recipes')
  //     .select()
  //     .eq('user_id', user.id)
  //     .order('created_at', ascending: false);
  //
  // return (response as List)
  //     .cast<Map<String, dynamic>>()
  //     .map((json) => Recipe.fromJson(json['recipe_data']))
  //     .toList();

  return []; // placeholder
});

/// Toggle favourite status for a recipe
final favouriteToggleProvider =
    Provider<FavouriteToggleNotifier>((ref) => FavouriteToggleNotifier(ref));

class FavouriteToggleNotifier {
  final Ref _ref;

  const FavouriteToggleNotifier(this._ref);

  /// Save a recipe to Supabase for the current user.
  Future<bool> save(Recipe recipe) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return false;

    try {
      // TODO: Implement with Supabase
      // await Supabase.instance.client.from('saved_recipes').upsert({
      //   'user_id': user.id,
      //   'recipe_id': recipe.id,
      //   'recipe_name': recipe.name,
      //   'recipe_image': recipe.image,
      //   'recipe_data': recipe.toJson(),
      // });
      // _ref.invalidate(savedRecipesProvider);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Remove a recipe from saved list
  Future<bool> unsave(String recipeId) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return false;

    try {
      // TODO: Implement with Supabase
      // await Supabase.instance.client
      //     .from('saved_recipes')
      //     .delete()
      //     .eq('user_id', user.id)
      //     .eq('recipe_id', recipeId);
      // _ref.invalidate(savedRecipesProvider);
      return true;
    } catch (_) {
      return false;
    }
  }
}
