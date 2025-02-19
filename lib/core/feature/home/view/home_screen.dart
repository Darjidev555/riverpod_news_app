import 'package:devwidget/core/commanwidget/commantextwidget.dart';
import 'package:devwidget/core/commanwidget/newstile.dart';
import 'package:devwidget/core/commanwidget/trandingcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import '../viewmodel/hottestnews_provider.dart';
import '../viewmodel/newsforyou_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(hottestNewsProvider);
    ref.watch(newsForYouProvider);

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.black54,
        title: const CommonTextWidget(
          text: "News App",
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          const Trandingcard(),
          SizedBox(height: 2.h),
          const Newstile(),
        ],
      ),
    );
  }
}
