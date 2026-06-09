import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile/screens/mock_state.dart';
import 'package:mobile/screens/success_screen.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/widgets/primary_button.dart';
import 'package:mobile/widgets/section_card.dart';

class MoodScreen extends ConsumerWidget {
  const MoodScreen({super.key});

  static const routeName = '/mood';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMood = ref.watch(selectedMoodProvider);
    const moods = ['😊', '😢', '😠', '😴', '🤩'];

    void save() {
      final question = ref.read(mockQuestionProvider).value ?? '';
      final rawText = ref.read(entryTextProvider);
      final enrichedText = ref.read(enrichedTextProvider).value ?? rawText;
      final tone = ref.read(selectedToneProvider);
      final mood = ref.read(selectedMoodProvider);

      ApiService.saveEntry(question, rawText, enrichedText, tone, mood)
          .whenComplete(() => Navigator.pushNamed(context, SuccessScreen.routeName));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Duygunu Seç')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Bugünkü ruh hâlin nasıl?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 18),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: moods
                      .map(
                        (mood) => InkWell(
                          onTap: () => ref.read(selectedMoodProvider.notifier).state = mood,
                          borderRadius: BorderRadius.circular(18),
                          child: SectionCard(
                            child: Center(
                              child: Text(mood, style: const TextStyle(fontSize: 40)),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.badgeCheck, color: Color(0xFFC8A96E), size: 18),
                  const SizedBox(width: 8),
                  Text('Seçili: $selectedMood', style: const TextStyle(color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Kaydet',
                icon: LucideIcons.save,
                onPressed: save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
