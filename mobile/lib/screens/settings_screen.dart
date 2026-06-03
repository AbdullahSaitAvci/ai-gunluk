import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile/screens/mock_state.dart';
import 'package:mobile/widgets/section_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final biometricEnabled = ref.watch(biometricEnabledProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        children: [
          const Text('Gizlilik', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          SectionCard(
            child: SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(LucideIcons.bell),
              value: notificationsEnabled,
              onChanged: (value) => ref.read(notificationsEnabledProvider.notifier).state = value,
              title: const Text('Günlük bildirim'),
              subtitle: const Text('Saat 21:00 (mock)', style: TextStyle(color: Colors.white70)),
            ),
          ),
          const SizedBox(height: 14),
          SectionCard(
            child: SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(LucideIcons.lockKeyhole),
              value: biometricEnabled,
              onChanged: (value) => ref.read(biometricEnabledProvider.notifier).state = value,
              title: const Text('Biyometrik kilit'),
              subtitle: const Text('FaceID / Parmak izi (mock)', style: TextStyle(color: Colors.white70)),
            ),
          ),
          const SizedBox(height: 22),
          const Text('Hesap', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          const SectionCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(LucideIcons.circleUserRound),
              title: Text('Hesap bilgileri'),
              subtitle: Text('Mock kullanıcı: demo@ayna.ai', style: TextStyle(color: Colors.white70)),
            ),
          ),
          const SizedBox(height: 14),
          const SectionCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(LucideIcons.info),
              title: Text('Versiyon'),
              subtitle: Text('MVP UI - Mock mode', style: TextStyle(color: Colors.white70)),
            ),
          ),
        ],
      ),
    );
  }
}
