import 'package:get/get.dart';

mixin GetxNavigation on GetxController {
  final _navigateTo = Rx<String?>(null);

  Stream<String?> get navigateToStream => _navigateTo.stream;
  set navigateTo(String value) {
    _setValueWithoutDistinct(value);
  }

  void _setValueWithoutDistinct(String value) {
    _navigateTo.subject.add(value);
  }
}
