import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _openLogin(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (context, _, _) => const LoginScreen(),
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
            child: child,
          );
        },
      ),
    );
  }

  void _openHome(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (context, _, _) => const HomeScreen(),
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/onboarding/papuma_coast.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x33000000),
                  Color(0x00000000),
                  Color(0xCC000000),
                  Color(0xFF000000),
                ],
                stops: [0, 0.32, 0.67, 1],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Container(
                    width: 104,
                    height: 104,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.24),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 22,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/onboarding/jembergo_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: _WelcomeContent(
                                onOpenLogin: _openLogin,
                                onStart: _openHome,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeContent extends StatelessWidget {
  const _WelcomeContent({required this.onOpenLogin, required this.onStart});

  final void Function(BuildContext) onOpenLogin;
  final void Function(BuildContext) onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Discover the Ultimate\nWisata Jember Experience',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            height: 1.18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Jelajahi keindahan pantai eksotis, air terjun '
          'tersembunyi, dan agrowisata terbaik di Jember '
          'dalam satu genggaman.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xD9FFFFFF),
            fontSize: 14,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 34),
        SizedBox(
          width: double.infinity,
          height: 58,
          child: FilledButton(
            onPressed: () => onStart(context),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF172033),
              shape: const StadiumBorder(),
              elevation: 8,
              shadowColor: Colors.black54,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            child: const Text('Mulai Sekarang'),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sudah punya akun?',
              style: TextStyle(color: Color(0xD9FFFFFF), fontSize: 14),
            ),
            TextButton(
              onPressed: () => onOpenLogin(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.only(left: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0x99FFFFFF),
                ),
              ),
              child: const Text('Masuk'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: 128,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.42),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ],
    );
  }
}
