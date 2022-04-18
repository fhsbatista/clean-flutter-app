import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../../models/models.dart';

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({required this.fetchCacheStorage});

  Future<List<SurveyEntity>> load() async {
    final data = await fetchCacheStorage.fetch('surveys');
    if (data.isEmpty) {
      throw DomainError.unexpected;
    }
    return data
        .map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity())
        .toList();
  }
}
