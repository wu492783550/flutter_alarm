import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

// 提醒列表存储的 Key
const String reminderKey = 'daily_reminders';

class ReminderService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ReminderService(this.flutterLocalNotificationsPlugin);

  // 保存提醒时间列表
  Future<void> saveReminderList(List<Map<String, dynamic>> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(reminders);
    await prefs.setString(reminderKey, encoded);
  }

  // 读取提醒时间列表
  Future<List<Map<String, dynamic>>> loadReminderList() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(reminderKey);
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded.cast<Map<String, dynamic>>();
  }

  // 调度所有存储的提醒
  Future<void> scheduleStoredReminders() async {
    final reminders = await loadReminderList();

    const androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      '日常提醒',
      channelDescription: '每天多个时间段的提醒',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    for (var reminder in reminders) {
      final now = tz.TZDateTime.now(tz.local);
      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        reminder['hour'],
        reminder['minute'],
      );
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        reminder['id'],
        reminder['title'],
        reminder['body'],
        scheduled,
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  // 清除所有提醒
  Future<void> cancelAllReminders() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // 创建并保存默认提醒
  Future<void> createAndSaveDefaultReminders() async {
    final reminders = [
      {"id": 1, "hour": 10, "minute": 33, "title": "早安", "body": "记得吃早餐"},
      {"id": 2, "hour": 10, "minute": 35, "title": "午后", "body": "喝点水，休息一下"},
      {"id": 3, "hour": 10, "minute": 38, "title": "晚安", "body": "准备休息啦"},
    ];
    await saveReminderList(reminders);
    await scheduleStoredReminders();
  }
}
