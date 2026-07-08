import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/widgets/primary_button.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  static const routeName = '/success';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tamamlandı')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.circleCheckBig,
                size: 110,
                color: Color(0xFFC8A96E),
              ),
              const SizedBox(height: 24),
              const Text(
                'Kaydetme Başarılı 🎉',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const Text(
                'Günlüğün mock olarak kaydedildi.\nYarın yeni soruda tekrar buluşalım.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                label: 'Ana Sayfaya Dön',
                icon: LucideIcons.house,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomeScreen.routeName,
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
