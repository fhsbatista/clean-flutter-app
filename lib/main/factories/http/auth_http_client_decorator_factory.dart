import '../factories.dart';
import '../../decorators/decorators.dart';
import '../../../data/http/http.dart';

HttpClient makeAuthHttpAdapterDecorator() {
  return AuthHttpClientDecorator(
    makeSecureStorageAdapter(),
    makeHttpAdapter(),
  );
}
