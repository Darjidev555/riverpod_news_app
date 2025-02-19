import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/newsmodel.dart';
import '../../../network/network_services.dart';

class NewsState {
  final List<NewsModel> trendingNewsList;
  final List<NewsModel> newsForYouList;
  final bool isTrendingLoading;
  final bool isNewsForYouLoading;
  final bool isTrendingMoreLoading;
  final bool isNewsForYouMoreLoading;
  final int trendingPage;
  final int newsForYouPage;

  NewsState({
    required this.trendingNewsList,
    required this.newsForYouList,
    required this.isTrendingLoading,
    required this.isNewsForYouLoading,
    required this.isTrendingMoreLoading,
    required this.isNewsForYouMoreLoading,
    required this.trendingPage,
    required this.newsForYouPage,
  });

  NewsState copyWith({
    List<NewsModel>? trendingNewsList,
    List<NewsModel>? newsForYouList,
    bool? isTrendingLoading,
    bool? isNewsForYouLoading,
    bool? isTrendingMoreLoading,
    bool? isNewsForYouMoreLoading,
    int? trendingPage,
    int? newsForYouPage,
  }) {
    return NewsState(
      trendingNewsList: trendingNewsList ?? this.trendingNewsList,
      newsForYouList: newsForYouList ?? this.newsForYouList,
      isTrendingLoading: isTrendingLoading ?? this.isTrendingLoading,
      isNewsForYouLoading: isNewsForYouLoading ?? this.isNewsForYouLoading,
      isTrendingMoreLoading:
          isTrendingMoreLoading ?? this.isTrendingMoreLoading,
      isNewsForYouMoreLoading:
          isNewsForYouMoreLoading ?? this.isNewsForYouMoreLoading,
      trendingPage: trendingPage ?? this.trendingPage,
      newsForYouPage: newsForYouPage ?? this.newsForYouPage,
    );
  }
}

class NewsNotifier extends StateNotifier<NewsState> {
  final NetworkAPICall _networkAPICall = NetworkAPICall();

  NewsNotifier()
      : super(NewsState(
          trendingNewsList: [],
          newsForYouList: [],
          isTrendingLoading: false,
          isNewsForYouLoading: false,
          isTrendingMoreLoading: false,
          isNewsForYouMoreLoading: false,
          trendingPage: 1,
          newsForYouPage: 1,
        ));

  ///get trending news
  Future<void> getTrendingNews({bool loadMore = true}) async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=feac6772bf7143e1976d85e79fb8633a";

    try {
      var response = await _networkAPICall.get(url, isAddBaseUrl: true);
      var articles = response['articles'];
      List<NewsModel> newsList =
          articles.map<NewsModel>((news) => NewsModel.fromJson(news)).toList();

      state = state.copyWith(
        trendingNewsList: [...state.trendingNewsList, ...newsList],
        isTrendingLoading: false,
        isTrendingMoreLoading: false,
      );
    } catch (e) {
      print("Error fetching trending news: $e");
      state = state.copyWith(
          isTrendingLoading: false, isTrendingMoreLoading: false);
    }
  }

  ///get news for you
  Future<void> getNewsForYou({bool loadMore = true}) async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=feac6772bf7143e1976d85e79fb8633a";

    try {
      var response = await _networkAPICall.get(url, isAddBaseUrl: true);
      var articles = response['articles'];
      List<NewsModel> newsList =
          articles.map<NewsModel>((news) => NewsModel.fromJson(news)).toList();

      state = state.copyWith(
        newsForYouList: [...state.newsForYouList, ...newsList],
        isNewsForYouLoading: false,
        isNewsForYouMoreLoading: false,
      );
    } catch (e) {
      print("Error fetching news for you: $e");
      state = state.copyWith(
          isNewsForYouLoading: false, isNewsForYouMoreLoading: false);
    }
  }

  /// search news
  Future<void> searchNews(String search,
      {String country = "us", String category = "business"}) async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=$country&category=$category&q=$search&apiKey=feac6772bf7143e1976d85e79fb8633a";

    try {
      var response = await _networkAPICall.get(url, isAddBaseUrl: true);
      var articles = response['articles'];
      List<NewsModel> newsList =
          articles.map<NewsModel>((news) => NewsModel.fromJson(news)).toList();

      state =
          state.copyWith(newsForYouList: newsList, isNewsForYouLoading: false);
    } catch (e) {
      print("Error searching news: $e");
      state = state.copyWith(isNewsForYouLoading: false);
    }
  }
}

final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  return NewsNotifier();
});
