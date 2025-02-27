import 'package:devwidget/core/commanwidget/colorpref.dart';
import 'package:devwidget/core/commanwidget/commantextwidget.dart';
import 'package:devwidget/core/commanwidget/newsdetails.dart';
import 'package:devwidget/core/constants/const.dart';
import 'package:devwidget/core/feature/home/viewmodel/likedNews_provider.dart';
import 'package:devwidget/core/feature/home/viewmodel/newsforyou_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final selectedColorProvider = StateProvider.family<Color, String>((ref, key) {
  // Default to transparent if no color is saved
  return Colors.transparent;
});

// Helper function to initialize the color from SharedPreferences
Future<void> initializeColor(WidgetRef ref, String key) async {
  final savedColor = await ColorPreferences.getColor(key);
  if (savedColor != null) {
    ref.read(selectedColorProvider(key).notifier).state = savedColor;
  }
}

class Newstile extends ConsumerWidget {
  const Newstile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final likedNews = ref.watch(likedNewsProvider);
    final newsForYouState = ref.watch(newsForYouProvider);

    //JSON color data
    final List<Map<String, String>> colors = [
      {"name": "Green", "color": "#7BC043"},
      {"name": "Blue", "color": "#0392CF"},
      {"name": "Red", "color": "#FF0000"},
    ];

    // Convert hex colors to Color objects
    List<Color> colorList = colors.map((color) {
      return Color(int.parse(color["color"]!.replaceFirst("#", "0xFF")));
    }).toList();

    if (newsForYouState.newsForYouList.isEmpty && !newsForYouState.isLoading) {
      ref.read(newsForYouProvider.notifier).getNewsForYou();
    }

    return newsForYouState.isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: theme.hintColor,
            ),
          )
        : Column(
            children: [
              Row(
                children: [
                  CommonTextWidget(
                    text: "News For You",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.hintColor,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              ListView.builder(
                itemCount: newsForYouState.newsForYouList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final uniqueKey =
                      "${newsForYouState.newsForYouList[index].title}-$index";
                  initializeColor(ref, uniqueKey);

                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 500),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, (1 - value) * 50),
                        child: Opacity(opacity: value, child: child!),
                      );
                    },
                    child: Slidable(
                      enabled: true,
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: colorList.map((color) {
                          return SlidableAction(
                            flex: 2,
                            onPressed: (context) async {
                              ref
                                  .read(
                                      selectedColorProvider(uniqueKey).notifier)
                                  .state = color;
                              await ColorPreferences.saveColor(
                                  uniqueKey, color);
                            },
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            label: colors[colorList.indexOf(color)]["name"],
                            icon: Icons.save,
                          );
                        }).toList(),
                      ),
                      child: InkWell(
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
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.only(bottom: 2.h),
                          padding: EdgeInsets.all(3.w),
                          height: 19.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.w),
                            color: theme.scaffoldBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: theme.hintColor.withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ],
                            border: Border.all(
                              color:
                                  ref.watch(selectedColorProvider(uniqueKey)),
                              width: 3,
                            ),
                          ),
                          child: Row(
                            children: [
                              Hero(
                                tag:
                                    "newsImage-${newsForYouState.newsForYouList[index].title}-$index",
                                child: Container(
                                  height: 14.h,
                                  width: 13.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.w),
                                    color: theme.primaryColorDark,
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.hintColor.withOpacity(0.3),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      )
                                    ],
                                    border: Border.all(
                                      color: theme.dividerColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3.w),
                                    child: Image.network(
                                      newsForYouState.newsForYouList[index]
                                              .urlToImage ??
                                          "https://www.hindustantimes.com/ht-img/img/2024/10/07/550x309/Prime-Minister-Narendra-Modi-and-Maldives-Presiden_1728317636195_1728317752751.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 1.5.h,
                                          backgroundColor: theme.hintColor,
                                          child: Center(
                                            child: Text(
                                              newsForYouState
                                                          .newsForYouList[index]
                                                          .author !=
                                                      null
                                                  ? newsForYouState
                                                      .newsForYouList[index]
                                                      .author![0]
                                                  : "?",
                                              style: TextStyle(
                                                color: theme.textTheme
                                                    .bodyMedium?.color,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                        Flexible(
                                          child: Text(
                                            newsForYouState
                                                    .newsForYouList[index]
                                                    .author ??
                                                "Unknown Author",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: theme.textTheme
                                                        .bodyMedium?.color),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      newsForYouState
                                              .newsForYouList[index].title ??
                                          "No Title",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formatDate(newsForYouState
                                              .newsForYouList[index]
                                              .publishedAt),
                                          maxLines: 1,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme.hintColor,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            final uniqueKey =
                                                "${newsForYouState.newsForYouList[index].title}-$index";
                                            ref
                                                .read(
                                                    likedNewsProvider.notifier)
                                                .toggleLike(uniqueKey);
                                          },
                                          child: Consumer(
                                            builder: (context, ref, child) {
                                              final likedNews =
                                                  ref.watch(likedNewsProvider);
                                              final uniqueKey =
                                                  "${newsForYouState.newsForYouList[index].title}-$index";
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
                                                      : theme.iconTheme.color,
                                                  size: 4.h,
                                                ),
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
                      ),
                    ),
                  );
                },
              ),
            ],
          );
  }
}
