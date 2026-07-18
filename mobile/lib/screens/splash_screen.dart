import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/onboarding_screen.dart';
import 'package:mobile/widgets/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  /// Splash süresi sonunda oturum durumuna göre Home ya da Onboarding'e geçer.
  void _goNext() {
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      final session = Supabase.instance.client.auth.currentSession;
      final routeName = session != null
          ? HomeScreen.routeName
          : OnboardingScreen.routeName;
      Navigator.pushReplacementNamed(context, routeName);
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
