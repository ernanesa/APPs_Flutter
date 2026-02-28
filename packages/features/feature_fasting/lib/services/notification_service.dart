import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  Future<void> initialize() async {}
  Future<void> requestPermissions() async {}
  Future<void> scheduleFastingEndNotification(dynamic session, {String? title, String? body}) async {}
  Future<void> cancelAll() async {}
}
