import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile/screens/mock_state.dart';
import 'package:mobile/widgets/section_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  static const routeName = '/history';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(mockHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Geçmiş')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        itemBuilder: (_, index) {
          final item = entries[index];
          return SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(item['mood'] ?? '😊', style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 10),
                    Text(item['date'] ?? '-', style: const TextStyle(color: Colors.white70)),
                    const Spacer(),
                    const Icon(LucideIcons.chevronRight, size: 16, color: Colors.white60),
                  ],
                ),
                const SizedBox(height: 12),
                Text(item['title'] ?? '-', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                const SizedBox(height: 8),
                const Text(
                  'Bugün yaşadıklarıma daha sakin bakmayı seçtim. Küçük bir adım bile değerli hissettirdi.',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, separatorIndex) => const SizedBox(height: 14),
        itemCount: entries.length,
      ),
    );
  }
}
