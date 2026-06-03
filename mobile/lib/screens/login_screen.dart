import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/widgets/primary_button.dart';
import 'package:mobile/widgets/section_card.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(LucideIcons.sparkles, size: 24, color: Color(0xFFC8A96E)),
              const SizedBox(height: 10),
              const Text('Ayna AI', style: TextStyle(fontSize: 18, color: Colors.white70)),
              const Spacer(),
              const SectionCard(
                child: Column(
                  children: [
                    Text('Tek dokunuşla devam et', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                    SizedBox(height: 12),
                    Text(
                      'Mock giriş ekranı. Gerçek auth bağlantısı yok.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              PrimaryButton(
                label: 'Google ile gir (Mock)',
                icon: LucideIcons.logIn,
                onPressed: () => Navigator.pushReplacementNamed(context, HomeScreen.routeName),
              ),
              const SizedBox(height: 18),
              PrimaryButton(
                label: 'Apple ile gir (Mock)',
                icon: LucideIcons.logIn,
                onPressed: () => Navigator.pushReplacementNamed(context, HomeScreen.routeName),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
