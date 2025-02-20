import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    /// Request permissions
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

    /// Get FCM Token
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    /// Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settingsInitialization =
        InitializationSettings(android: androidSettings);

    await _localNotificationsPlugin.initialize(settingsInitialization);

    /// Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: ${message.notification?.title}");

      _showLocalNotification(
        message.notification?.title ?? "New Notification",
        message.notification?.body ?? "You have a new message",
      );
    });

    /// Handle notification click when the app is in background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("User clicked on the notification!");
    });

    /// Ensure notifications appear in foreground on iOS & Android 13+
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'firebase_channel',
      'firebase_notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      0,
      title,
      body,
      details,
    );
  }
}
