import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile/screens/mock_state.dart';
import 'package:mobile/screens/mood_screen.dart';
import 'package:mobile/widgets/primary_button.dart';
import 'package:mobile/widgets/section_card.dart';

class EnrichScreen extends ConsumerWidget {
  const EnrichScreen({super.key});

  static const routeName = '/enrich';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTone = ref.watch(selectedToneProvider);
    final enrichedAsync = ref.watch(enrichedTextProvider);
    const tones = ['Neşeli', 'Hüzünlü', 'Minnettar', 'Motive', 'Sakin'];

    return Scaffold(
      appBar: AppBar(title: const Text('Zenginleştir')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ton Seçimi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              Column(
                children: tones
                    .map(
                      (tone) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => ref.read(selectedToneProvider.notifier).state = tone,
                          borderRadius: BorderRadius.circular(18),
                          child: SectionCard(
                            child: Row(
                              children: [
                                Icon(
                                  tone == selectedTone ? LucideIcons.check : LucideIcons.circle,
                                  color: tone == selectedTone ? const Color(0xFFC8A96E) : Colors.white54,
                                ),
                                const SizedBox(width: 12),
                                Text(tone, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
              const Text('AI Çıktısı', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: SectionCard(
                    child: enrichedAsync.when(
                      data: (text) => Text(
                        text.isEmpty ? 'Bir şeyler yaz, sonra tonu seç.' : text,
                        style: const TextStyle(height: 1.5),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Hata: $e', style: const TextStyle(color: Colors.redAccent)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              PrimaryButton(
                label: 'Duygu Seçimine Devam Et',
                icon: LucideIcons.smile,
                onPressed: () => Navigator.pushNamed(context, MoodScreen.routeName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
