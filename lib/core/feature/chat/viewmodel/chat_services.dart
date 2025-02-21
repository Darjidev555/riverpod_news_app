import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initializeNotifications(
      Function(String) onNotificationTap) async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          onNotificationTap(response.payload!);
        }
      },
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void listenForMessages(String chatId, String currentUserId) {
    _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var message = snapshot.docs.last;
        String senderId = message['senderId'];

        if (senderId != currentUserId) {
          _showLocalNotification(message['senderName'], message['text']);
        }
      }
    });
  }

  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> sendMessage(
      String chatId, String senderId, String message) async {
    String senderName = _auth.currentUser?.displayName ?? "Unknown";

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'text': message,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': FieldValue.serverTimestamp(),
    });

    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _sendPushNotification(token, senderName, message);
    }
  }

  static Future<void> _sendPushNotification(
      String token, String senderName, String message) async {
    // Here you need to integrate with your backend server to send the FCM notification
    print("Sending push notification to token: $token");
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Background Message: ${message.notification?.title}");
    _showLocalNotification(
      message.notification?.title ?? "New Message",
      message.notification?.body ?? "You have a new message",
    );
  }

  static Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
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
