import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import '../constants/const.dart';
import '../feature/home/viewmodel/hottestNews_provider.dart';
import '../feature/home/viewmodel/likedNews_provider.dart'; // Import your theme provider
import 'commantextwidget.dart';
import 'newsdetails.dart';

class Trandingcard extends ConsumerWidget {
  const Trandingcard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedNews = ref.watch(likedNewsProvider);
    final hottestNewsState = ref.watch(hottestNewsProvider);
    final theme = Theme.of(context);

    if (hottestNewsState.hottestNewsList.isEmpty &&
        !hottestNewsState.isLoading) {
      ref.read(hottestNewsProvider.notifier).getHottestNews();
    }

    return Column(
      children: [
        Row(
          children: [
            CommonTextWidget(
              text: "Hottest News",
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: theme.hintColor, // Use theme color
            ),
          ],
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 42.h,
          child: hottestNewsState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hottestNewsState.hottestNewsList.length,
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.only(right: 2.w),
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: Duration(milliseconds: 600),
                        builder: (context, double value, child) {
                          return Transform.translate(
                            offset: Offset(0, (1 - value) * 20),
                            child: Opacity(opacity: value, child: child!),
                          );
                        },
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetails(
                                    newsModel: hottestNewsState
                                        .hottestNewsList[index]),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(1.5.w),
                            height: 45.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.primaryColor.withOpacity(0.1),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  )
                                ],
                                color: theme.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(4.w)),
                            child: Column(
                              children: [
                                Hero(
                                  tag:
                                      "newsImage-${hottestNewsState.hottestNewsList[index].urlToImage}",
                                  child: Container(
                                    height: 25.h,
                                    width: 70.w,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: theme.hintColor,
                                            // Theme color
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(4.w)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4.w),
                                      child: Image.network(
                                        hottestNewsState.hottestNewsList[index]
                                                .urlToImage ??
                                            "https://www.hindustantimes.com/ht-img/img/2024/10/07/550x309/Prime-Minister-Narendra-Modi-and-Maldives-Presiden_1728317636195_1728317752751.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Trending No 1",
                                        style: TextStyle(
                                            color: theme
                                                .textTheme.bodyMedium!.color,
                                            fontSize: 14.sp)),
                                    Text(
                                      formatDate(hottestNewsState
                                          .hottestNewsList[index].publishedAt),
                                      style: TextStyle(
                                          color: theme.hintColor,
                                          fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                        child: Text(
                                      hottestNewsState
                                              .hottestNewsList[index].title ??
                                          "No Title",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: theme
                                              .textTheme.bodyMedium!.color),
                                      maxLines: 2,
                                    ))
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      radius: 3.w,
                                      backgroundColor: theme.hintColor,
                                      child: Center(
                                        child: Text(
                                          hottestNewsState
                                                      .hottestNewsList[index]
                                                      .author !=
                                                  null
                                              ? hottestNewsState
                                                  .hottestNewsList[index]
                                                  .author![0]
                                              : "?",
                                          style: TextStyle(
                                              color: theme
                                                  .textTheme.bodyMedium!.color,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 1.w),
                                    Flexible(
                                      child: Text(
                                        hottestNewsState.hottestNewsList[index]
                                                .author ??
                                            "Unknown Author",
                                        style: TextStyle(
                                            color: theme
                                                .textTheme.bodyMedium!.color,
                                            fontSize: 15.sp),
                                        maxLines: 1,
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
                                          final isLiked =
                                              likedNews.contains(uniqueKey);
                                          return AnimatedSwitcher(
                                            duration:
                                                Duration(milliseconds: 900),
                                            transitionBuilder:
                                                (child, animation) =>
                                                    ScaleTransition(
                                              scale: animation,
                                              child: child,
                                            ),
                                            child: Icon(
                                              isLiked
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              key: ValueKey(isLiked),
                                              color: isLiked
                                                  ? Colors.red
                                                  : theme.textTheme.bodyMedium!
                                                      .color,
                                              size: 4.h,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
        ),
      ],
    );
  }
}
