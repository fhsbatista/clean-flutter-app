import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({required this.cacheStorage});

  Future<List<SurveyEntity>> load() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      if (data == null || data.isEmpty) {
        throw DomainError.unexpected;
      }
      return _toSurveyEntities(data);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      _toSurveyEntities(data);
    } catch (error) {
      cacheStorage.delete('surveys');
    }
  }

  Future<void> save(List<SurveyEntity> surveys) async {
    try {
      await cacheStorage.save(key: 'surveys', value: _toSurveyMaps(surveys));
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  List<SurveyEntity> _toSurveyEntities(dynamic data) {
    return data
        .map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity())
        .toList();
  }

  List<Map> _toSurveyMaps(List<SurveyEntity> surveys) {
    return surveys.map((e) => LocalSurveyModel.fromEntity(e).toJson()).toList();
  }
}
