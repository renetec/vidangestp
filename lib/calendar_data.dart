import 'package:flutter/material.dart';

enum CollectionType {
  recyclage,
  ordures,
  compost,
  encombrants,
  feuilles,
  conseil,
}

class CollectionEvent {
  final DateTime date;
  final CollectionType type;
  final String title;

  CollectionEvent({
    required this.date,
    required this.type,
    required this.title,
  });
}

class CalendarData {
  static const Color colorRecyclage = Color(0xFF2D89C8);
  static const Color colorOrdures = Color(0xFF333333);
  static const Color colorCompost = Color(0xFF8B4513);
  static const Color colorEncombrants = Color(0xFFD32F2F);
  static const Color colorLeaves = Color(0xFF4CAF50);
  static const Color colorConseil = Color(0xFF795548);

  static List<CollectionEvent> getEvents() {
    List<CollectionEvent> events = [];

    // Recyclage (Tuesdays, every 2 weeks)
    List<DateTime> recyclageDates = [
      DateTime(2026, 1, 13), DateTime(2026, 1, 27),
      DateTime(2026, 2, 10), DateTime(2026, 2, 24),
      DateTime(2026, 3, 10), DateTime(2026, 3, 24),
      DateTime(2026, 4, 7), DateTime(2026, 4, 21),
      DateTime(2026, 5, 5), DateTime(2026, 5, 19),
      DateTime(2026, 6, 2), DateTime(2026, 6, 16), DateTime(2026, 6, 30),
      DateTime(2026, 7, 14), DateTime(2026, 7, 28),
      DateTime(2026, 8, 11), DateTime(2026, 8, 25),
      DateTime(2026, 9, 8), DateTime(2026, 9, 22),
      DateTime(2026, 10, 6), DateTime(2026, 10, 20),
      DateTime(2026, 11, 3), DateTime(2026, 11, 17),
      DateTime(2026, 12, 1), DateTime(2026, 12, 15), DateTime(2026, 12, 29),
    ];
    for (var date in recyclageDates) {
      events.add(CollectionEvent(date: date, type: CollectionType.recyclage, title: "Recyclage (Bac bleu)"));
    }

    // Ordures (Wednesdays, every 2 weeks)
    List<DateTime> ordureDates = [
      DateTime(2026, 1, 14), DateTime(2026, 1, 28),
      DateTime(2026, 2, 11), DateTime(2026, 2, 25),
      DateTime(2026, 3, 11), DateTime(2026, 3, 25),
      DateTime(2026, 4, 8), DateTime(2026, 4, 22),
      DateTime(2026, 5, 6), DateTime(2026, 5, 20),
      DateTime(2026, 6, 3), DateTime(2026, 6, 17),
      DateTime(2026, 7, 1), DateTime(2026, 7, 15), DateTime(2026, 7, 29),
      DateTime(2026, 8, 12), DateTime(2026, 8, 26),
      DateTime(2026, 9, 9), DateTime(2026, 9, 23),
      DateTime(2026, 10, 7), DateTime(2026, 10, 21),
      DateTime(2026, 11, 4), DateTime(2026, 11, 18),
      DateTime(2026, 12, 2), DateTime(2026, 12, 16), DateTime(2026, 12, 30),
    ];
    for (var date in ordureDates) {
      events.add(CollectionEvent(date: date, type: CollectionType.ordures, title: "Ordures (Bac noir)"));
    }

    // Compost (Mondays)
    List<DateTime> compostDates = [
      DateTime(2026, 1, 19),
      DateTime(2026, 2, 16),
      DateTime(2026, 3, 16),
      DateTime(2026, 4, 13), DateTime(2026, 4, 27),
      DateTime(2026, 5, 11), DateTime(2026, 5, 25),
      // Weekly in June, July, August, Sept, Oct, Nov
      ..._generateWeeklyDates(2026, 6, 1, 5, DateTime.monday),
      ..._generateWeeklyDates(2026, 7, 6, 4, DateTime.monday),
      ..._generateWeeklyDates(2026, 8, 3, 5, DateTime.monday),
      ..._generateWeeklyDates(2026, 9, 14, 3, DateTime.monday), // Sept 7 is gavel, compost starts 14
      ..._generateWeeklyDates(2026, 10, 12, 3, DateTime.monday), // Oct 5 is gavel, compost starts 12
      ..._generateWeeklyDates(2026, 11, 9, 4, DateTime.monday), // Nov 2 is gavel
      DateTime(2026, 12, 14),
    ];
    for (var date in compostDates) {
      events.add(CollectionEvent(date: date, type: CollectionType.compost, title: "Matières organiques (Bac brun)"));
    }

    // Conseil Municipal
    List<DateTime> conseilDates = [
      DateTime(2026, 1, 5), DateTime(2026, 2, 2), DateTime(2026, 3, 2),
      DateTime(2026, 4, 6), DateTime(2026, 5, 4), DateTime(2026, 6, 1),
      DateTime(2026, 7, 6), DateTime(2026, 8, 3), DateTime(2026, 9, 7),
      DateTime(2026, 10, 5), DateTime(2026, 11, 2), DateTime(2026, 12, 7),
    ];
    for (var date in conseilDates) {
      events.add(CollectionEvent(date: date, type: CollectionType.conseil, title: "Conseil municipal"));
    }

    // Encombrants
    events.add(CollectionEvent(date: DateTime(2026, 9, 10), type: CollectionType.encombrants, title: "Encombrants"));

    return events;
  }

  static List<DateTime> _generateWeeklyDates(int year, int month, int startDay, int count, int dayOfWeek) {
    List<DateTime> dates = [];
    DateTime current = DateTime(year, month, startDay);
    for (int i = 0; i < count; i++) {
      dates.add(current);
      current = current.add(const Duration(days: 7));
    }
    return dates;
  }
}
