import 'package:devwidget/core/commanwidget/commantextwidget.dart';
import 'package:devwidget/core/commanwidget/newstile.dart';
import 'package:devwidget/core/commanwidget/trandingcard.dart';
import 'package:devwidget/core/feature/chat/view/chat_Screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../viewmodel/hottestnews_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/newsforyou_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(hottestNewsProvider);
    ref.watch(newsForYouProvider);

    return Scaffold(
      backgroundColor: Colors.white30,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.black87,
        title: const CommonTextWidget(
          text: "News App",
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(chatId: "chatId1")));
              },
              icon: Icon(Icons.chat))
        ],
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 900),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: ListView(
          key: ValueKey("news_list"),
          padding: const EdgeInsets.all(10.0),
          children: [
            const Trandingcard(),
            SizedBox(height: 2.h),
            const Newstile(),
          ],
        ),
      ),
    );
  }
}
