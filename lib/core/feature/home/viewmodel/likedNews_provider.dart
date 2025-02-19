import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final likedNewsProvider = StateNotifierProvider<LikedNewsNotifier, Set<String>>(
  (ref) => LikedNewsNotifier(),
);

class LikedNewsNotifier extends StateNotifier<Set<String>> {
  LikedNewsNotifier() : super({}) {
    _loadLikedNews();
  }

  Future<void> _loadLikedNews() async {
    final prefs = await SharedPreferences.getInstance();
    final likedNews = prefs.getStringList('liked_news') ?? [];
    state = likedNews.toSet();
  }

  Future<void> toggleLike(String news) async {
    final prefs = await SharedPreferences.getInstance();
    final updatedLikes = Set<String>.from(state);

    if (updatedLikes.contains(news)) {
      updatedLikes.remove(news);
    } else {
      updatedLikes.add(news);
    }

    state = updatedLikes;
    await prefs.setStringList('liked_news', updatedLikes.toList());
  }
}
