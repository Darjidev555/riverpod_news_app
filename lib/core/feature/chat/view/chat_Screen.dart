import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../viewmodel/chat_services.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  ChatScreen({required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _listenForMessages();
  }

  /// Initialize local notifications
  void _initializeNotifications() {
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    _localNotificationsPlugin.initialize(settings);
  }

  /// Listen for incoming messages and show notification in foreground
  void _listenForMessages() {
    _chatService.getMessages(widget.chatId).listen((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var message = snapshot.docs.last.data() as Map<String, dynamic>;
        String senderId = message['senderId'];

        // Show notification only if message is from another user
        if (senderId != _auth.currentUser?.uid) {
          _showLocalNotification(message['senderName'], message['text']);
        }
      }
    });
  }

  /// Show local notification for foreground messages
  Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(0, title, body, details);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Chat", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessages()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(widget.chatId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No messages yet"));
        }

        var messages = snapshot.data!.docs;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var data = messages[index].data() as Map<String, dynamic>;

            /// Identify if the message is from the authenticated user
            bool isMe = _auth.currentUser?.uid == data['senderId'];

            /// Format timestamp
            String formattedTime = data['timestamp'] != null
                ? DateFormat('hh:mm a')
                    .format((data['timestamp'] as Timestamp).toDate())
                : "";

            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['senderName'] ?? "Unknown",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2),

                    // Message Bubble
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.teal[400] : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft:
                              isMe ? Radius.circular(15) : Radius.circular(0),
                          bottomRight:
                              isMe ? Radius.circular(0) : Radius.circular(15),
                        ),
                      ),
                      child: Text(
                        data['text'],
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    /// Timestamp Display
                    Padding(
                      padding: EdgeInsets.only(top: 3, left: 5, right: 5),
                      child: Text(
                        formattedTime,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: "Type a message...",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.teal,
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    _chatService.sendMessage(
      widget.chatId,
      _auth.currentUser!.uid,

      /// Sender ID
      _messageController.text.trim(),

      /// Message
    );

    _messageController.clear();
    _focusNode.requestFocus();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
