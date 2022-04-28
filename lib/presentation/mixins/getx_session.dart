import 'package:get/get.dart';

mixin GetxSession {
  final _isSessionExpired = false.obs;

  Stream<bool> get isSessionExpiredStream => _isSessionExpired.stream;
  set isSessionExpired(bool value) => _isSessionExpired.value = value;
}
