import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'new_sound_channel', 'channelName',
          channelDescription: '这是非常重要的通知',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          // 启用声音
          enableVibration: true,
          // 启用振动
          visibility: NotificationVisibility.public,
          // sound: RawResourceAndroidNotificationSound('default'),
        ),

        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String title, String body, String payLoad}) async {
    print("showNotification1111");
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }
}
