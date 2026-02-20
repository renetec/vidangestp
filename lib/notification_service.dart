import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'calendar_data.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Initialisation avec les paramètres nommés requis pour la v20.1.0
    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Optionnel : Gérer le clic sur la notification
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    
    // Demander la permission (Requis pour Android 13+)
    await _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  // Cette fonction doit être statique et de premier niveau ou annotée @pragma('vm:entry-point')
  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse details) {
    // Optionnel : Gérer le clic en arrière-plan
  }

  static Future<void> scheduleAllReminders() async {
    await _notificationsPlugin.cancelAll();

    final events = CalendarData.getEvents();
    final now = DateTime.now();

    int id = 0;
    for (var event in events) {
      if (event.date.isBefore(now)) continue;

      if (event.type == CollectionType.recyclage || 
          event.type == CollectionType.ordures || 
          event.type == CollectionType.conseil) {
        
        final scheduledDate = DateTime(
          event.date.year,
          event.date.month,
          event.date.day - 1,
          19, 0,
        );

        if (scheduledDate.isBefore(now)) continue;

        try {
          await _notificationsPlugin.zonedSchedule(
            id: id++,
            title: 'Rappel : ${event.title}',
            body: 'C\'est demain ! N\'oubliez pas de sortir votre bac ce soir.',
            scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
            notificationDetails: const NotificationDetails(
              android: AndroidNotificationDetails(
                'vidange_reminders',
                'Rappels de collecte',
                channelDescription: 'Rappels pour sortir les bacs la veille',
                importance: Importance.max,
                priority: Priority.high,
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          );
        } catch (e) {
          debugPrint("Erreur planification notification $id: $e");
        }
      }
    }
  }

  static Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'vidange_test_channel',
      'Test Notifications',
      channelDescription: 'Canal pour tester les notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    await _notificationsPlugin.show(
      id: 999, // ID unique pour le test
      title: 'Test de Notification',
      body: 'Si vous voyez ceci, les rappels de vidange fonctionneront !',
      notificationDetails: platformChannelSpecifics,
    );
  }
}
