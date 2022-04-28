import 'package:get/get.dart';

mixin GetxFormValidation on GetxController {
  final _isFormValid = false.obs;

  Stream<bool> get isFormValidStream => _isFormValid.stream;
  set isFormValid(bool error) => _isFormValid.value = error;
}
