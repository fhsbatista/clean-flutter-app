import '../../data/usecases/usecases.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../domain/entities/entities.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final RemoteLoadSurveys remote;
  final LocalLoadSurveys local;

  RemoteLoadSurveysWithLocalFallback({
    required this.remote,
    required this.local,
  });

  Future<List<SurveyEntity>> load() async {
    try {
      final surveys = await remote.load();
      await local.save(surveys);
      return surveys;
    } catch (error) {
      if (error == DomainError.access_denied) {
        rethrow;
      }
      try {
        await local.validate();
        final surveys = await local.load();
        return surveys;
      } catch (_) {
        throw DomainError.unexpected;
      }
    }
  }
}
