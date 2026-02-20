import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'home_screen.dart';
import 'notification_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // On lance l'app immédiatement
  runApp(const VidangeSTPApp());

  // On configure les notifications en arrière-plan
  Future.delayed(Duration.zero, () async {
    try {
      await NotificationService.init();
      await NotificationService.scheduleAllReminders();
    } catch (e) {
      debugPrint("Erreur notifications: $e");
    }
  });
}

class VidangeSTPApp extends StatelessWidget {
  const VidangeSTPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saint-Pacôme Vidanges 2026',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
      ],
      home: const HomeScreen(),
    );
  }
}
