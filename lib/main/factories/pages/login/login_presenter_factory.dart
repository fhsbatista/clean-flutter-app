import '../../../../ui/pages/pages.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../factories.dart';

LoginPresenter makeStreamLoginPresenter() {
  return StreamLoginPresenter(
    validation: makeLoginValidation(),
    authentication: makeRemoteAuthentication(),
  );
}

LoginPresenter makeGetxLoginPresenter() {
  return GetxLoginPresenter(
    validation: makeLoginValidation(),
    authentication: makeRemoteAuthentication(),
    saveCurrentAccount: makeLocalSaveCurrentAccount(),
  );
}
