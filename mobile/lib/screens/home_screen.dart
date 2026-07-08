import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile/screens/entry_screen.dart';
import 'package:mobile/screens/history_screen.dart';
import 'package:mobile/screens/mock_state.dart';
import 'package:mobile/screens/settings_screen.dart';
import 'package:mobile/widgets/primary_button.dart';
import 'package:mobile/widgets/section_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionAsync = ref.watch(mockQuestionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bugün Nasılsın?')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                'Günlük Soru',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: Center(
                  child: SectionCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.sparkles,
                          size: 22,
                          color: Color(0xFFC8A96E),
                        ),
                        const SizedBox(height: 16),
                        questionAsync.when(
                          loading: () => const CircularProgressIndicator(
                            color: Color(0xFFC8A96E),
                          ),
                          error: (e, _) => const Text(
                            'Bugün seni en çok ne düşündürdü?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              height: 1.45,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          data: (question) => Text(
                            question,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              height: 1.45,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PrimaryButton(
                label: 'Cevabını Yaz',
                icon: LucideIcons.pencilLine,
                onPressed: () =>
                    Navigator.pushNamed(context, EntryScreen.routeName),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: 'Takvim',
                icon: LucideIcons.scrollText,
                onPressed: () =>
                    Navigator.pushNamed(context, HistoryScreen.routeName),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: 'Ayarlar',
                icon: LucideIcons.settings,
                onPressed: () =>
                    Navigator.pushNamed(context, SettingsScreen.routeName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
