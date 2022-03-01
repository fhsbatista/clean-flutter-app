import '../../../../ui/pages/pages.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../factories.dart';

LoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(
    validation: makeLoginValidation(),
    authentication: makeRemoteAuthentication(),
  );
}
