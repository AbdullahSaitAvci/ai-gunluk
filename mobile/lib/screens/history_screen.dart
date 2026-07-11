import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mobile/screens/mock_state.dart';
import 'package:mobile/widgets/section_card.dart';
import 'package:mobile/widgets/mood_banner.dart';

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _moodFor(dynamic raw) {
  if (raw is String && raw.isNotEmpty) return raw;
  final score = raw is int ? raw : int.tryParse(raw?.toString() ?? '');
  return switch (score) {
    1 => '😢',
    2 => '😠',
    3 => '😴',
    4 => '🤩',
    5 => '😊',
    _ => '😊',
  };
}

Color _moodMarkerColor(String mood) {
  switch (mood) {
    case '🤩':
      return const Color(0xFFFF9966);
    case '😊':
      return const Color(0xFF7FB685);
    case '😢':
      return const Color(0xFF6FA8DC);
    case '😠':
      return const Color(0xFFE05A4E);
    case '😴':
      return const Color(0xFFB8B8E8);
    default:
      return const Color(0xFFC8A96E);
  }
}

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  static const routeName = '/history';

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Future<void> _handleRefresh() async {
    ref.invalidate(historyProvider);
    try {
      await ref.read(historyProvider.future);
    } catch (_) {
      // hata zaten error: dalında gösteriliyor, burada sadece spinner süresi için bekliyoruz
    }
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Takvim')),
      body: RefreshIndicator(
        color: const Color(0xFFC8A96E),
        backgroundColor: const Color(0xFF1A1A1A),
        onRefresh: _handleRefresh,
        child: entriesAsync.when(
          loading: () => LayoutBuilder(
            builder: (context, constraints) => ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              children: [
                SizedBox(
                  height: constraints.maxHeight,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
          error: (err, _) => LayoutBuilder(
            builder: (context, constraints) => ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              children: [
                SizedBox(
                  height: constraints.maxHeight,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Yüklenemedi',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 6),
                          // ApiException.toString() kullanıcıya gösterilebilir Türkçe
                          // mesaj döner (örn. "Sunucuya ulaşılamadı (zaman aşımı).")
                          Text(
                            err.toString(),
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 14),
                          TextButton(
                            onPressed: () => ref.invalidate(historyProvider),
                            child: const Text(
                              'Tekrar Dene',
                              style: TextStyle(color: Color(0xFFC8A96E)),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'ya da aşağı çekip yenile',
                            style: TextStyle(
                              color: Colors.white24,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          data: (entries) {
            final entryMoodByDay = <DateTime, String>{};
            for (final e in entries) {
              try {
                final d = DateTime.parse(e['date'] as String);
                entryMoodByDay[DateTime(d.year, d.month, d.day)] = _moodFor(
                  e['mood'],
                );
              } catch (_) {}
            }

            final dayEntries = entries.where((e) {
              try {
                final d = DateTime.parse(e['date'] as String);
                return _isSameDay(
                  DateTime(d.year, d.month, d.day),
                  _selectedDay,
                );
              } catch (_) {
                return false;
              }
            }).toList();

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              children: [
                Container(
                  color: const Color(0xFF1A1A1A),
                  child: TableCalendar(
                    locale: 'tr_TR',
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {CalendarFormat.month: ''},
                    selectedDayPredicate: (day) =>
                        _isSameDay(day, _selectedDay),
                    onDaySelected: (selected, focused) {
                      setState(() {
                        _selectedDay = selected;
                        _focusedDay = focused;
                      });
                    },
                    eventLoader: (day) {
                      final d = DateTime(day.year, day.month, day.day);
                      final mood = entryMoodByDay[d];
                      return mood != null ? [mood] : [];
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        if (events.isEmpty) return null;
                        final mood = events.first as String;
                        return Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _moodMarkerColor(mood),
                          ),
                        );
                      },
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: const Color(0xFFC8A96E).withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Color(0xFFC8A96E),
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: const TextStyle(color: Colors.white),
                      weekendTextStyle: const TextStyle(color: Colors.white70),
                      outsideTextStyle: const TextStyle(color: Colors.white24),
                      todayTextStyle: const TextStyle(color: Colors.white),
                      selectedTextStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: Color(0xFFC8A96E),
                        shape: BoxShape.circle,
                      ),
                      markerSize: 5.0,
                      markersMaxCount: 1,
                      markerMargin: const EdgeInsets.only(top: 1),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                      headerPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      weekendStyle: TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const Divider(color: Colors.white12, height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('d MMMM yyyy', 'tr_TR').format(_selectedDay),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                if (dayEntries.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(
                      child: Text(
                        'Bu gün için kayıt yok.',
                        style: TextStyle(color: Colors.white38),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                    child: SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MoodBanner(mood: _moodFor(dayEntries.first['mood'])),
                          const SizedBox(height: 10),
                          Text(
                            _moodFor(dayEntries.first['mood']),
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            dayEntries.first['question'] ?? '-',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dayEntries.first['enriched_text'] ?? '',
                            style: const TextStyle(
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
