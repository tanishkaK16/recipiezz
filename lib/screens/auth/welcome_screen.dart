import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/cozy_theme.dart';
import '../../widgets/cute_button.dart';
import '../../utils/constants.dart';

/// 👋 WelcomeScreen
///
/// The first screen users see — a warm landing page presenting the app.
/// Currently acts as the auth decision screen.
///
/// Next steps:
/// - Add Supabase auth check (if already logged in → push /home)
/// - Build sign-in / sign-up flows
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CozyTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLg),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // 🍰 Hero illustration placeholder
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: CozyTheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: CozyTheme.border, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: CozyTheme.primary.withAlpha(30),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🍰', style: TextStyle(fontSize: 80)),
                ),
              ),

              const SizedBox(height: 40),

              // App name
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: CozyTheme.primary,
                    ),
              ),

              const SizedBox(height: 12),

              // Tagline
              Text(
                AppConstants.appTagline,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: CozyTheme.textMuted,
                    ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 3),

              // CTA buttons
              CuteButton.primary(
                label: 'Get Started 🍳',
                width: double.infinity,
                onPressed: () {
                  // TODO: Navigate to Sign Up screen
                  context.go('/home');
                },
              ),

              const SizedBox(height: 12),

              CuteButton.secondary(
                label: 'I already have an account',
                width: double.infinity,
                onPressed: () {
                  // TODO: Navigate to Login screen
                  context.go('/home');
                },
              ),

              const SizedBox(height: 32),

              // Legal footer
              Text(
                'By continuing, you agree to our Terms & Privacy Policy.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.paddingMd),
            ],
          ),
        ),
      ),
    );
  }
}
