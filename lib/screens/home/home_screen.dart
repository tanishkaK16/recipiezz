import 'package:flutter/material.dart';
import '../../theme/cozy_theme.dart';
import '../../utils/constants.dart';

/// 🏠 HomeScreen
///
/// The main app shell — placeholder until the full navigation and
/// feature screens are built.
///
/// Next steps:
/// - Replace with a NavigationBar shell (Home / Discover / AI Magic / My Book)
/// - Implement the actual home dashboard with featured recipes
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const _navItems = [
    (icon: Icons.home_rounded, label: AppConstants.navHome),
    (icon: Icons.explore_rounded, label: AppConstants.navDiscover),
    (icon: Icons.auto_awesome_rounded, label: AppConstants.navAiMagic),
    (icon: Icons.menu_book_rounded, label: AppConstants.navMyBook),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CozyTheme.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🍪 '),
            Text(
              AppConstants.appName,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Open user profile / settings
            },
            icon: const CircleAvatar(
              radius: 16,
              backgroundColor: CozyTheme.border,
              child: Text('👤', style: TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _HomeBody(selectedIndex: _selectedIndex),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: _navItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Home body — placeholder content
// ---------------------------------------------------------------------------

class _HomeBody extends StatelessWidget {
  final int selectedIndex;

  const _HomeBody({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real screen widgets for each tab
    final placeholders = [
      _PlaceholderTab(
        emoji: '🏡',
        title: 'Home coming soon!',
        subtitle: 'Featured recipes & daily inspiration will live here.',
      ),
      _PlaceholderTab(
        emoji: '🔍',
        title: 'Discover coming soon!',
        subtitle: 'Search & browse thousands of recipes from TheMealDB.',
      ),
      _PlaceholderTab(
        emoji: '✨',
        title: 'AI Magic coming soon!',
        subtitle: 'Tell Gemini what\'s in your fridge — get a recipe!',
      ),
      _PlaceholderTab(
        emoji: '📖',
        title: 'My Book coming soon!',
        subtitle: 'Your saved & personalised recipe collection.',
      ),
    ];

    return AnimatedSwitcher(
      duration: AppConstants.animNormal,
      child: placeholders[selectedIndex],
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const _PlaceholderTab({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      key: ValueKey(title),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CozyTheme.textMuted,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
