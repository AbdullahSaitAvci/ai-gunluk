import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
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

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  static const routeName = '/history';

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Takvim')),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Text('Yüklenemedi', style: TextStyle(color: Colors.white70)),
        ),
        data: (entries) {
          final entryDays = <DateTime>{};
          for (final e in entries) {
            try {
              final d = DateTime.parse(e['date'] as String);
              entryDays.add(DateTime(d.year, d.month, d.day));
            } catch (_) {}
          }

          final dayEntries = entries.where((e) {
            try {
              final d = DateTime.parse(e['date'] as String);
              return _isSameDay(DateTime(d.year, d.month, d.day), _selectedDay);
            } catch (_) {
              return false;
            }
          }).toList();

          return Column(
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
                  selectedDayPredicate: (day) => _isSameDay(day, _selectedDay),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      _selectedDay = selected;
                      _focusedDay = focused;
                    });
                  },
                  eventLoader: (day) {
                    final d = DateTime(day.year, day.month, day.day);
                    return entryDays.contains(d) ? [true] : [];
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: const Color(0xFFC8A96E).withOpacity(0.35),
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
                    selectedTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
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
                    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                    headerPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.white70, fontSize: 12),
                    weekendStyle: TextStyle(color: Colors.white38, fontSize: 12),
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
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ),
              ),
              Expanded(
                child: dayEntries.isEmpty
                    ? const Center(
                        child: Text(
                          'Bu gün için kayıt yok.',
                          style: TextStyle(color: Colors.white38),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                        itemCount: dayEntries.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (_, index) {
                          final item = dayEntries[index];
                          return SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _moodEmoji(item['mood']),
                                  style: const TextStyle(fontSize: 28),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item['question'] ?? '-',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['enriched_text'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
