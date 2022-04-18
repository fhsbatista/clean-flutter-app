import 'package:fordev/data/cache/cache.dart';

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({required this.fetchCacheStorage});

  Future<void> load() async {
    return fetchCacheStorage.fetch('surveys');
  }
}
