import 'package:get/get.dart';

mixin GetxSession on GetxController {
  final _isSessionExpired = false.obs;

  Stream<bool> get isSessionExpiredStream => _isSessionExpired.stream;
  set isSessionExpired(bool value) => _isSessionExpired.value = value;
}
