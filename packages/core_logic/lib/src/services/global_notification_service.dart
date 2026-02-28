import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalNotificationProvider = Provider<GlobalNotificationService>((ref) {
  return GlobalNotificationService();
});

class GlobalNotificationService {
  Future<void> initialize() async {}
  Future<void> requestPermissions() async {}
  Future<void> showNotification({required int id, required String title, required String body}) async {}
  Future<void> scheduleDailyEngagementReminder() async {}
}
