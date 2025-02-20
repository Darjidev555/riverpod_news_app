import 'package:devwidget/core/constants/const.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/newsmodel.dart';
import '../../../network/network_services.dart';

class NewsForYouState {
  final List<NewsModel> newsForYouList;
  final bool isLoading;
  final bool isMoreLoading;
  final int page;

  NewsForYouState({
    required this.newsForYouList,
    required this.isLoading,
    required this.isMoreLoading,
    required this.page,
  });

  NewsForYouState copyWith({
    List<NewsModel>? newsForYouList,
    bool? isLoading,
    bool? isMoreLoading,
    int? page,
  }) {
    return NewsForYouState(
      newsForYouList: newsForYouList ?? this.newsForYouList,
      isLoading: isLoading ?? this.isLoading,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
      page: page ?? this.page,
    );
  }
}

class NewsForYouNotifier extends StateNotifier<NewsForYouState> {
  final NetworkAPICall _networkAPICall = NetworkAPICall();

  NewsForYouNotifier()
      : super(NewsForYouState(
          newsForYouList: [],
          isLoading: false,
          isMoreLoading: false,
          page: 1,
        ));

  /// Fetch news for you
  Future<void> getNewsForYou({bool loadMore = false}) async {
    try {
      var response = await _networkAPICall.get(newsForYou, isAddBaseUrl: true);
      var articles = response['articles'];
      List<NewsModel> newsList =
          articles.map<NewsModel>((news) => NewsModel.fromJson(news)).toList();

      state = state.copyWith(
        newsForYouList: [...state.newsForYouList, ...newsList],
        isLoading: false,
        isMoreLoading: false,
      );
    } catch (e) {
      print("Error fetching news for you: $e");
      state = state.copyWith(isLoading: false, isMoreLoading: false);
    }
  }

  /// Search news
  Future<void> searchNews(String search,
      {String country = "us", String category = "business"}) async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=$country&category=$category&q=$search&apiKey=feac6772bf7143e1976d85e79fb8633a";

    try {
      var response = await _networkAPICall.get(url, isAddBaseUrl: true);
      var articles = response['articles'];
      List<NewsModel> newsList =
          articles.map<NewsModel>((news) => NewsModel.fromJson(news)).toList();

      state = state.copyWith(newsForYouList: newsList, isLoading: false);
    } catch (e) {
      print("Error searching news: $e");
      state = state.copyWith(isLoading: false);
    }
  }
}

final newsForYouProvider =
    StateNotifierProvider<NewsForYouNotifier, NewsForYouState>((ref) {
  return NewsForYouNotifier();
});
