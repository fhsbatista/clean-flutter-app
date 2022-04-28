import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxSplashPresenter extends GetxController with GetxNavigation implements SplashPresenter {
  GetxSplashPresenter({required this.loadCurrentAccount});

  final LoadCurrentAccount loadCurrentAccount;

  @override
  Future<void> checkAccount({int delayInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: 2));
    try {
      final account = await loadCurrentAccount.load();
      navigateTo = account == null ? '/login' : '/surveys';
    } catch (error) {
      navigateTo = '/login';
    }
  }
}
