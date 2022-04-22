import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/main/composites/composites.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_load_surveys_with_local_fallback_test.mocks.dart';

@GenerateMocks([RemoteLoadSurveys])
void main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late MockRemoteLoadSurveys remote;

  void mockRemote() {
    when(remote.load()).thenAnswer((_) async => []);
  }

  setUp(() {
    remote = MockRemoteLoadSurveys();
    sut = RemoteLoadSurveysWithLocalFallback(
      remote: remote,
    );
    mockRemote();
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });
}
