import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile/screens/onboarding_screen.dart';
import 'package:mobile/widgets/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  /// Splash görüntüsünden onboarding ekranına geçiş yapar.
  void _goNext() {
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, OnboardingScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.sparkles, size: 64, color: AppTheme.primary),
            SizedBox(height: 16),
            Text(
              'Ayna AI',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
