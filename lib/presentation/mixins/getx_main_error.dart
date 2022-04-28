import 'package:get/get.dart';

import '../../ui/helpers/errors/errors.dart';

mixin GetxMainError {
  final _mainError = Rx<UIError?>(null);

  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? error) => _mainError.value = error;
}
