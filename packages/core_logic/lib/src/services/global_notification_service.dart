import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalNotificationProvider = Provider<GlobalNotificationService>((ref) {
  return GlobalNotificationService();
});

class GlobalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(requestBadgePermission: false);
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    
    await _plugin.initialize(initSettings);
  }

  Future<void> requestPermissions() async {
    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    await _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> showNotification({required int id, required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails('gamification_channel', 'Engagement', importance: Importance.max, priority: Priority.high);
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _plugin.show(id, title, body, details);
  }

  // NOVO: Agendamento de Engajamento
  Future<void> scheduleDailyEngagementReminder() async {
    // Implementação simplificada para demonstração de engajamento
    // Em um cenário real, usaria timezone e cron.
    await showNotification(
      id: 999,
      title: '🔥 Não perca sua ofensiva!',
      body: 'Volte ao app para manter seu Streak e ganhar mais XP hoje.',
    );
  }
}
