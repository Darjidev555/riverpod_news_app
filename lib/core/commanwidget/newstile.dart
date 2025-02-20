import 'package:devwidget/core/commanwidget/newsdetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devwidget/core/feature/home/viewmodel/likedNews_provider.dart';
import 'package:devwidget/core/feature/home/viewmodel/newsForYou_provider.dart';
import 'package:sizer/sizer.dart';
import '../constants/const.dart';
import 'commantextwidget.dart';

class Newstile extends ConsumerWidget {
  const Newstile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedNews = ref.watch(likedNewsProvider);
    final newsForYouState = ref.watch(newsForYouProvider);

    if (newsForYouState.newsForYouList.isEmpty && !newsForYouState.isLoading) {
      ref.read(newsForYouProvider.notifier).getNewsForYou();
    }

    return newsForYouState.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              const Row(
                children: [
                  CommonTextWidget(
                    text: "News For You",
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              SizedBox(
                child: ListView.builder(
                  itemCount: newsForYouState.newsForYouList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetails(
                                newsModel:
                                    newsForYouState.newsForYouList[index]),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(10),
                        height: 125,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white30,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blueAccent,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  newsForYouState
                                          .newsForYouList[index].urlToImage ??
                                      "https://www.hindustantimes.com/ht-img/img/2024/10/07/550x309/Prime-Minister-Narendra-Modi-and-Maldives-Presiden_1728317636195_1728317752751.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.orange),
                                      const SizedBox(width: 3),
                                      Flexible(
                                        child: Text(
                                          newsForYouState.newsForYouList[index]
                                                  .author ??
                                              "Unknown Author",
                                          maxLines: 1,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    newsForYouState
                                            .newsForYouList[index].title ??
                                        "No Title",
                                    maxLines: 2,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formatDate(newsForYouState
                                            .newsForYouList[index].publishedAt),
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: Colors.orange),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          final uniqueKey =
                                              "${newsForYouState.newsForYouList[index].title}-$index";

                                          ref
                                              .read(likedNewsProvider.notifier)
                                              .toggleLike(uniqueKey);
                                        },
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            final likedNews =
                                                ref.watch(likedNewsProvider);
                                            final uniqueKey =
                                                "${newsForYouState.newsForYouList[index].title}-$index";
                                            final isLiked = likedNews.contains(
                                                uniqueKey); // Check using unique key

                                            return Icon(
                                              isLiked
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isLiked
                                                  ? Colors.red
                                                  : Colors.white,
                                              size: 30,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
