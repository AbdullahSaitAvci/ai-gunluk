import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/services/api_service.dart'; // YENİ

// mockQuestionProvider'ı AsyncNotifierProvider'a çevirdik
// FutureProvider: async veri için Riverpod'un standart çözümü
final mockQuestionProvider = FutureProvider<String>((ref) async {
  return ApiService.getDailyQuestion();
});

// Geri kalanlar aynı kalıyor
final entryTextProvider = StateProvider<String>((ref) => '');
final selectedToneProvider = StateProvider<String>((ref) => 'Sakin');
final enrichedTextProvider = FutureProvider<String>((ref) async {
  final tone = ref.watch(selectedToneProvider);
  final rawText = ref.watch(entryTextProvider);
  if (rawText.trim().isEmpty) return '';
  return ApiService.enrichEntry(rawText.trim(), tone);
});
final selectedMoodProvider = StateProvider<String>((ref) => '😊');
final historyProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ApiService.getEntries();
});
final notificationsEnabledProvider = StateProvider<bool>((ref) => true);
final biometricEnabledProvider = StateProvider<bool>((ref) => true);
