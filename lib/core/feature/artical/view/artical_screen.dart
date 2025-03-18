import 'package:devwidget/core/commanwidget/newsdetails.dart';
import 'package:devwidget/core/commanwidget/newstile.dart';
import 'package:devwidget/core/commanwidget/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../home/viewmodel/newsforyou_provider.dart';

class ArticalScreen extends ConsumerWidget {
  const ArticalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final newsForYouState = ref.watch(newsForYouProvider);

    String formatDate(DateTime? date) {
      if (date == null) {
        return "Unknown Date";
      }
      return DateFormat('yyyy-MM-dd').format(date);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        centerTitle: true,
        title: Text(
          "Artical ",
          style: TextStyle(color: theme.hintColor, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: theme.highlightColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Column(
              children: [
                Newstile(),
              ],
            )
          ],
        ),
      )),
    );
  }
}
