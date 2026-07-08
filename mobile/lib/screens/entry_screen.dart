import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile/screens/enrich_screen.dart';
import 'package:mobile/screens/mock_state.dart';
import 'package:mobile/screens/mood_screen.dart';
import 'package:mobile/widgets/primary_button.dart';
import 'package:mobile/widgets/section_card.dart';

class EntryScreen extends ConsumerStatefulWidget {
  const EntryScreen({super.key});

  static const routeName = '/entry';

  @override
  ConsumerState<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends ConsumerState<EntryScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(entryTextProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Yanıt metnini Riverpod state'inde saklar.
  void _onChanged(String value) {
    ref.read(entryTextProvider.notifier).state = value;
  }

  @override
  Widget build(BuildContext context) {
    final questionAsync = ref.watch(mockQuestionProvider);
    final text = ref.watch(entryTextProvider);
    final remaining = 500 - text.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Günlük Girişi')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              questionAsync.when(
                data: (q) => Text(
                  q,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                loading: () => const Text(
                  'Yükleniyor...',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white54,
                  ),
                ),
                error: (_, _) => const Text(
                  'Bugün ne hissettin?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: SectionCard(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
                  child: TextField(
                    controller: _controller,
                    onChanged: _onChanged,
                    maxLength: 500,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(fontSize: 17, height: 1.4),
                    decoration: const InputDecoration(
                      hintText: 'Buraya yaz...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '$remaining karakter kaldı',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Zenginleştir',
                icon: LucideIcons.wandSparkles,
                onPressed: text.trim().isEmpty
                    ? null
                    : () =>
                          Navigator.pushNamed(context, EnrichScreen.routeName),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(LucideIcons.save, size: 18),
                  label: const Text('Direkt Kaydet'),
                  onPressed: text.trim().isEmpty
                      ? null
                      : () {
                          ref.invalidate(enrichedTextProvider);
                          Navigator.pushNamed(context, MoodScreen.routeName);
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white54,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
