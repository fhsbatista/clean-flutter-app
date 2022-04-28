import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../mixins/mixins.dart';
import '../pages.dart';

import '../../helpers/i18n/i18n.dart';
import '../../components/components.dart';

import 'components/components.dart';

class SignUpPage extends StatefulWidget {
  final SignUpPresenter presenter;

  SignUpPage(this.presenter);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with Keyboard, Loading, MainUIError, Navigation {
  @override
  void dispose() {
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          handleLoading(context, widget.presenter.isLoadingStream);
          handleMainUIError(context, widget.presenter.mainErrorStream);
          handleNavigation(widget.presenter.navigateToStream, clear: true);

          return GestureDetector(
            onTap: () => hideKeyboard(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  const SizedBox(height: 32),
                  Headline1(text: I18n.strings.addAccount),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: ListenableProvider(
                      create: (context) => widget.presenter,
                      child: Form(
                        child: Column(
                          children: [
                            NameInput(),
                            const SizedBox(height: 8),
                            EmailInput(),
                            const SizedBox(height: 8),
                            PasswordInput(),
                            const SizedBox(height: 8),
                            PasswordConfirmationInput(),
                            const SizedBox(height: 32),
                            SignUpButton(),
                            TextButton.icon(
                              onPressed: widget.presenter.login,
                              icon: Icon(Icons.exit_to_app),
                              label: Text(I18n.strings.login),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
