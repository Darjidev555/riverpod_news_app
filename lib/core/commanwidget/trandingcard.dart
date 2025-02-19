import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import '../constants/const.dart';
import '../feature/home/viewmodel/hottestNews_provider.dart';
import '../feature/home/viewmodel/likedNews_provider.dart';
import 'commantextwidget.dart';
import 'newsdetails.dart';

class Trandingcard extends ConsumerWidget {
  const Trandingcard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedNews = ref.watch(likedNewsProvider);
    final hottestNewsState = ref.watch(hottestNewsProvider);

    if (hottestNewsState.hottestNewsList.isEmpty &&
        !hottestNewsState.isLoading) {
      ref.read(hottestNewsProvider.notifier).getHottestNews();
    }

    return Column(
      children: [
        const Row(
          children: [
            CommonTextWidget(
              text: "Hottest News",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ],
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 53.h,
          child: hottestNewsState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hottestNewsState.hottestNewsList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetails(
                                newsModel:
                                    hottestNewsState.hottestNewsList[index]),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(5),
                        height: 345,
                        width: 280,
                        decoration: BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              width: 270,
                              decoration: BoxDecoration(
                                  color: Colors.white38,
                                  borderRadius: BorderRadius.circular(20)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    hottestNewsState.hottestNewsList[index]
                                            .urlToImage ??
                                        "https://www.hindustantimes.com/ht-img/img/2024/10/07/550x309/Prime-Minister-Narendra-Modi-and-Maldives-Presiden_1728317636195_1728317752751.jpg",
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Traning no 1",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  formatDate(hottestNewsState
                                      .hottestNewsList[index].publishedAt),
                                  style: const TextStyle(color: Colors.orange),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: Text(
                                  hottestNewsState
                                          .hottestNewsList[index].title ??
                                      "No Title",
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.white),
                                  maxLines: 2,
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                const CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.orange,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Text(
                                    maxLines: 1,
                                    hottestNewsState
                                            .hottestNewsList[index].author ??
                                        "Unknown Author",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    final uniqueKey =
                                        "${hottestNewsState.hottestNewsList[index].title}-$index";

                                    ref
                                        .read(likedNewsProvider.notifier)
                                        .toggleLike(uniqueKey);
                                  },
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      final likedNews =
                                          ref.watch(likedNewsProvider);
                                      final uniqueKey =
                                          "${hottestNewsState.hottestNewsList[index].title}-$index";
                                      final isLiked = likedNews.contains(
                                          uniqueKey); // Check using unique key

                                      return Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color:
                                            isLiked ? Colors.red : Colors.white,
                                        size: 30,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
        ),
      ],
    );
  }
}
