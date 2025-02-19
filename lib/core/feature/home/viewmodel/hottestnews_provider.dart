import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/newsmodel.dart';
import '../../../network/network_services.dart';

class HottestNewsState {
  final List<NewsModel> hottestNewsList;
  final bool isLoading;
  final bool isMoreLoading;

  HottestNewsState({
    required this.hottestNewsList,
    required this.isLoading,
    required this.isMoreLoading,
  });

  HottestNewsState copyWith({
    List<NewsModel>? hottestNewsList,
    bool? isLoading,
    bool? isMoreLoading,
  }) {
    return HottestNewsState(
      hottestNewsList: hottestNewsList ?? this.hottestNewsList,
      isLoading: isLoading ?? this.isLoading,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
    );
  }
}

class HottestNewsNotifier extends StateNotifier<HottestNewsState> {
  final NetworkAPICall _networkAPICall = NetworkAPICall();

  HottestNewsNotifier()
      : super(HottestNewsState(
          hottestNewsList: [],
          isLoading: false,
          isMoreLoading: false,
        ));

  /// Fetch hottest news
  Future<void> getHottestNews({bool loadMore = false}) async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=feac6772bf7143e1976d85e79fb8633a";

    try {
      var response = await _networkAPICall.get(url, isAddBaseUrl: true);
      var articles = response['articles'];
      List<NewsModel> newsList =
          articles.map<NewsModel>((news) => NewsModel.fromJson(news)).toList();

      state = state.copyWith(
        hottestNewsList: [...state.hottestNewsList, ...newsList],
        isLoading: false,
        isMoreLoading: false,
      );
    } catch (e) {
      print("Error fetching hottest news: $e");
      state = state.copyWith(isLoading: false, isMoreLoading: false);
    }
  }
}

final hottestNewsProvider =
    StateNotifierProvider<HottestNewsNotifier, HottestNewsState>((ref) {
  return HottestNewsNotifier();
});
