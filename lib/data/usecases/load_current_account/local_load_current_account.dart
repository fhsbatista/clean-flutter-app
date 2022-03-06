import '../../cache/cache.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  FetchSecureCacheStorage fetchSecureCacheStorage;

  Future<AccountEntity?> load() async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      if (token == null) {
        return null;
      }
      return AccountEntity(token: token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
