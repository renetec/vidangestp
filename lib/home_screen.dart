import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calendar_data.dart';
import 'monthly_calendar.dart';
import 'notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = CalendarData.getEvents();
    final now = DateTime.now();
    // For demo purposes, if it's 2026, use now. Otherwise, use Jan 1st 2026.
    final referenceDate = now.year == 2026 ? now : DateTime(2026, 1, 1);
    
    final upcomingEvents = events.where((e) => e.date.isAfter(referenceDate.subtract(const Duration(days: 1)))).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final nextEvent = upcomingEvents.isNotEmpty ? upcomingEvents.first : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Saint-Pacôme 2026",
          style: GoogleFonts.newsreader(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Colors.blue),
            onPressed: () {
              NotificationService.showTestNotification();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Test de notification envoyé !')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MonthlyCalendar()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNextCollectionCard(nextEvent),
            const SizedBox(height: 30),
            Text(
              "Prochaines Collectes",
              style: GoogleFonts.newsreader(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: upcomingEvents.take(10).length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                return _buildCollectionItem(upcomingEvents[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextCollectionCard(CollectionEvent? event) {
    if (event == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PROCHAINE COLLECTE",
            style: GoogleFonts.inter(
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            event.title,
            style: GoogleFonts.newsreader(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: _getColorForType(event.type),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            DateFormat('EEEE d MMMM', 'fr_FR').format(event.date),
            style: GoogleFonts.inter(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionItem(CollectionEvent event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            color: _getColorForType(event.type),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  DateFormat('EEEE d MMMM', 'fr_FR').format(event.date),
                  style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _getIconForType(event.type),
        ],
      ),
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

  Widget _getIconForType(CollectionType type) {
    IconData icon;
    Color color = _getColorForType(type);
    switch (type) {
      case CollectionType.recyclage: icon = Icons.recycling; break;
      case CollectionType.ordures: icon = Icons.delete; break;
      case CollectionType.compost: icon = Icons.eco; break;
      case CollectionType.encombrants: icon = Icons.archive; break;
      case CollectionType.feuilles: icon = Icons.park; break;
      case CollectionType.conseil: icon = Icons.gavel; break;
    }
    return Icon(icon, color: color, size: 28);
  }
}
