import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../feature/home/view/news_provider.dart';

class Search extends ConsumerWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsState = ref.watch(newsProvider);
    TextEditingController searchController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              //controller: searchController,
              decoration: InputDecoration(
                hintText: "Search News",
                hintStyle: const TextStyle(fontSize: 15.0, color: Colors.white),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[600],
              ),
            ),
          ),
          Container(
            height: 48,
            width: 50,
            color: Colors.orange,
            child: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
