import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calendar_data.dart';

class MonthlyCalendar extends StatefulWidget {
  const MonthlyCalendar({super.key});

  @override
  State<MonthlyCalendar> createState() => _MonthlyCalendarState();
}

class _MonthlyCalendarState extends State<MonthlyCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime(2026, 1, 1);
  DateTime? _selectedDay;
  late final Map<DateTime, List<CollectionEvent>> _events;

  @override
  void initState() {
    super.initState();
    _events = {};
    for (var event in CalendarData.getEvents()) {
      final date = DateTime(event.date.year, event.date.month, event.date.day);
      if (_events[date] == null) _events[date] = [];
      _events[date]!.add(event);
    }
  }

  List<CollectionEvent> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Vue Mensuelle",
          style: GoogleFonts.newsreader(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'fr_FR',
            firstDay: DateTime(2026, 1, 1),
            lastDay: DateTime(2026, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: GoogleFonts.newsreader(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return null;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: events.map((event) {
                    final e = event as CollectionEvent;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _getColorForType(e.type),
                        shape: BoxShape.circle,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          _buildLegend(),
          const Divider(),
          Expanded(
            child: _buildSelectedDayEvents(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          _legendItem(CalendarData.colorRecyclage, "Recyclage"),
          _legendItem(CalendarData.colorOrdures, "Ordures"),
          _legendItem(CalendarData.colorCompost, "Compost"),
          _legendItem(CalendarData.colorConseil, "Conseil"),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 12)),
      ],
    );
  }

  Widget _buildSelectedDayEvents() {
    final dayEvents = _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];
    if (dayEvents.isEmpty) {
      return Center(
        child: Text(
          "Aucune collecte ce jour",
          style: GoogleFonts.inter(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: dayEvents.length,
      itemBuilder: (context, index) {
        final event = dayEvents[index];
        return ListTile(
          leading: Icon(Icons.circle, color: _getColorForType(event.type), size: 12),
          title: Text(event.title, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
        );
      },
    );
  }

  Color _getColorForType(CollectionType type) {
    switch (type) {
      case CollectionType.recyclage: return CalendarData.colorRecyclage;
      case CollectionType.ordures: return CalendarData.colorOrdures;
      case CollectionType.compost: return CalendarData.colorCompost;
      case CollectionType.encombrants: return CalendarData.colorEncombrants;
      case CollectionType.feuilles: return CalendarData.colorLeaves;
      case CollectionType.conseil: return CalendarData.colorConseil;
    }
  }
}
