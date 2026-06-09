import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile/screens/mock_state.dart';
import 'package:mobile/widgets/section_card.dart';

String _moodEmoji(dynamic score) {
  final s = score is int ? score : int.tryParse(score.toString()) ?? 3;
  return switch (s) {
    1 => '😢',
    2 => '😠',
    3 => '😴',
    4 => '😊',
    _ => '🤩',
  };
}

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  static const routeName = '/history';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Geçmiş')),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Text('Yüklenemedi', style: TextStyle(color: Colors.white70)),
        ),
        data: (entries) => entries.isEmpty
            ? const Center(
                child: Text('Henüz kayıt yok.', style: TextStyle(color: Colors.white70)),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (_, index) {
                  final item = entries[index];
                  return SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(_moodEmoji(item['mood']), style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 10),
                            Text(item['date'] ?? '-', style: const TextStyle(color: Colors.white70)),
                            const Spacer(),
                            const Icon(LucideIcons.chevronRight, size: 16, color: Colors.white60),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['question'] ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['enriched_text'] ?? '',
                          style: const TextStyle(color: Colors.white70, height: 1.4),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
