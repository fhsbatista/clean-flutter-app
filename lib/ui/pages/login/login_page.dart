import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../mixins/mixins.dart';
import '../pages.dart';
import '../../helpers/i18n/i18n.dart';
import '../../helpers/errors/errors.dart';
import '../../components/components.dart';

import 'components/components.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;

  LoginPage(this.presenter);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Keyboard {
  @override
  void dispose() {
    widget.presenter?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter?.isLoadingStream.listen((isLoading) async {
            if (isLoading) {
              await showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          widget.presenter?.mainErrorStream.listen((error) {
            if (error != null) {
              showErrorMessage(context, error.description);
            }
          });

          widget.presenter?.navigateToStream.listen((route) {
            if (route?.isNotEmpty ?? false) {
              Get.offAllNamed(route!);
            }
          });

          return GestureDetector(
            onTap: () => hideKeyboard(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  const SizedBox(height: 32),
                  Headline1(text: 'Login'),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: ListenableProvider(
                      create: (_) => widget.presenter,
                      child: Form(
                        child: Column(
                          children: [
                            EmailInput(),
                            const SizedBox(height: 8),
                            PasswordInput(),
                            const SizedBox(height: 32),
                            LoginButton(),
                            TextButton.icon(
                              onPressed: widget.presenter?.signUp,
                              icon: Icon(Icons.person),
                              label: Text(I18n.strings.addAccount),
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
