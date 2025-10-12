import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/grocery_item.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  
  static bool _initialized = false;

  // Initialize notifications
  static Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(initializationSettings);
    _initialized = true;
  }

  // Schedule notification for item expiry
  static Future<void> scheduleExpiryNotification(GroceryItem item) async {
    await initialize();

    // Schedule notification 1 day before expiry
    final notificationDate = item.expiryDate.subtract(const Duration(days: 1));
    
    if (notificationDate.isAfter(DateTime.now())) {
      await _notifications.zonedSchedule(
        item.id.hashCode,
        'Grocery Reminder',
        '${item.name} expires tomorrow!',
        tz.TZDateTime.from(notificationDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'grocery_reminders',
            'Grocery Expiry Reminders',
            channelDescription: 'Notifications for grocery item expiry',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    // Schedule notification on expiry day
    await _notifications.zonedSchedule(
      item.id.hashCode + 1000, // Different ID for same day notification
      'Grocery Expired',
      '${item.name} has expired today!',
      tz.TZDateTime.from(item.expiryDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'grocery_reminders',
          'Grocery Expiry Reminders',
          channelDescription: 'Notifications for grocery item expiry',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Cancel notification for item
  static Future<void> cancelNotification(String itemId) async {
    await _notifications.cancel(itemId.hashCode);
    await _notifications.cancel(itemId.hashCode + 1000);
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
