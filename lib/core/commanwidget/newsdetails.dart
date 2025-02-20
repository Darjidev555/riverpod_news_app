import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../feature/home/view/news_provider.dart';
import '../model/newsmodel.dart';

class NewsDetails extends ConsumerWidget {
  final NewsModel newsModel;

  const NewsDetails({super.key, required this.newsModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(newsProvider);

    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Back",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Display image dynamically from newsModel
                Container(
                  height: 330,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.network(
                    newsModel.urlToImage ??
                        "https://www.hindustantimes.com/ht-img/img/2024/10/07/550x309/Prime-Minister-Narendra-Modi-and-Maldives-Presiden_1728317636195_1728317752751.jpg",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image,
                            color: Colors.white, size: 50),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Display title dynamically from newsModel
                Text(
                  newsModel.title ?? "No Title Available",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                // Display date dynamically from newsModel
                Row(
                  children: [
                    Text(
                      newsModel.publishedAt != null
                          ? DateFormat('yyyy-MM-dd')
                              .format(newsModel.publishedAt!)
                          : "Unknown Date", // Use your preferred format
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Center(
                        child: Text(
                          newsModel.author != null ? newsModel.author![0] : "?",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        newsModel.author ?? "Unknown Author",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Display description dynamically from newsModel
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        newsModel.description ?? "No description available.",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
