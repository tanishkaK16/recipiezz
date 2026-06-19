import 'package:flutter/material.dart';
import '../theme/cozy_theme.dart';

/// 🃏 CozyCard
///
/// A warm, rounded card component used throughout Recipezz.
/// Wraps content in a soft surface with a subtle border and shadow.
///
/// Usage:
/// ```dart
/// CozyCard(
///   child: Text('Hello, cozy!'),
///   onTap: () {},
/// )
/// ```
class CozyCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final bool hasShadow;

  const CozyCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderRadius = 20,
    this.backgroundColor,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 150),
      child: Material(
        color: backgroundColor ?? CozyTheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: CozyTheme.primary.withAlpha(30),
          highlightColor: CozyTheme.primary.withAlpha(15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: CozyTheme.border, width: 1),
              boxShadow: hasShadow
                  ? [
                      BoxShadow(
                        color: CozyTheme.primary.withAlpha(18),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 🖼️ RecipeCard
///
/// A specialised card for displaying a recipe thumbnail in grid / list views.
class RecipeCard extends StatefulWidget {
  final String name;
  final String? imageUrl;
  final String? category;
  final String? area;
  final VoidCallback? onTap;
  final VoidCallback? onFavouriteTap;
  final bool isFavourite;

  const RecipeCard({
    super.key,
    required this.name,
    this.imageUrl,
    this.category,
    this.area,
    this.onTap,
    this.onFavouriteTap,
    this.isFavourite = false,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) {
        _controller.forward();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.forward(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: CozyTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: CozyTheme.border),
            boxShadow: [
              BoxShadow(
                color: CozyTheme.primary.withAlpha(18),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (widget.imageUrl != null)
                      Image.network(
                        widget.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _PlaceholderImage(),
                      )
                    else
                      _PlaceholderImage(),

                    // Favourite button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: widget.onFavouriteTap,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(220),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.isFavourite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: widget.isFavourite
                                ? CozyTheme.primary
                                : CozyTheme.textMuted,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Details
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (widget.category != null || widget.area != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        [
                          if (widget.category != null) widget.category!,
                          if (widget.area != null) widget.area!,
                        ].join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CozyTheme.border,
      child: const Center(
        child: Text('🍳', style: TextStyle(fontSize: 40)),
      ),
    );
  }
}
