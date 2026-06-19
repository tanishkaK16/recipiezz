import 'package:flutter/material.dart';
import '../theme/cozy_theme.dart';

/// 🔘 CuteButton
///
/// The primary CTA button for Recipezz, with a warm press animation.
///
/// Variants:
/// - [CuteButton.primary] — filled terracotta background
/// - [CuteButton.secondary] — outlined with terracotta border
/// - [CuteButton.ghost] — text only, no background
///
/// Usage:
/// ```dart
/// CuteButton(
///   label: 'Let\'s Cook! 🍳',
///   onPressed: () {},
/// )
/// ```
class CuteButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final CuteButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final double? width;

  const CuteButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = CuteButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  const CuteButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : variant = CuteButtonVariant.primary;

  const CuteButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : variant = CuteButtonVariant.secondary;

  const CuteButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : variant = CuteButtonVariant.ghost;

  @override
  State<CuteButton> createState() => _CuteButtonState();
}

class _CuteButtonState extends State<CuteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
    _scale = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
    }
  }

  void _onTapUp(TapUpDetails _) {
    _controller.forward();
    if (!widget.isLoading) widget.onPressed?.call();
  }

  void _onTapCancel() => _controller.forward();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: SizedBox(
          width: widget.width,
          child: _buildButton(context),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    switch (widget.variant) {
      case CuteButtonVariant.primary:
        return _PrimaryButton(
          label: widget.label,
          icon: widget.icon,
          isLoading: widget.isLoading,
          enabled: widget.onPressed != null,
        );
      case CuteButtonVariant.secondary:
        return _SecondaryButton(
          label: widget.label,
          icon: widget.icon,
          isLoading: widget.isLoading,
          enabled: widget.onPressed != null,
        );
      case CuteButtonVariant.ghost:
        return _GhostButton(
          label: widget.label,
          icon: widget.icon,
          isLoading: widget.isLoading,
          enabled: widget.onPressed != null,
        );
    }
  }
}

// ---------------------------------------------------------------------------
// Internal button variants
// ---------------------------------------------------------------------------

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool enabled;

  const _PrimaryButton({
    required this.label,
    this.icon,
    required this.isLoading,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1.0 : 0.5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          color: CozyTheme.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CozyTheme.primary.withAlpha(60),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _ButtonContent(
          label: label,
          icon: icon,
          isLoading: isLoading,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool enabled;

  const _SecondaryButton({
    required this.label,
    this.icon,
    required this.isLoading,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1.0 : 0.5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CozyTheme.primary, width: 1.5),
        ),
        child: _ButtonContent(
          label: label,
          icon: icon,
          isLoading: isLoading,
          color: CozyTheme.primary,
        ),
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool enabled;

  const _GhostButton({
    required this.label,
    this.icon,
    required this.isLoading,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1.0 : 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: _ButtonContent(
          label: label,
          icon: icon,
          isLoading: isLoading,
          color: CozyTheme.primary,
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isLoading;
  final Color color;

  const _ButtonContent({
    required this.label,
    this.icon,
    required this.isLoading,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 📦 Enum
// ---------------------------------------------------------------------------

enum CuteButtonVariant { primary, secondary, ghost }
