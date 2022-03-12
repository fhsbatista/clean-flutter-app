import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';

import '../../helpers/i18n/i18n.dart';
import '../../components/components.dart';

import 'components/components.dart';

class SignUpPage extends StatefulWidget {
  final SignUpPresenter? presenter;

  SignUpPage(this.presenter);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void dispose() {
    widget.presenter?.dispose();
    super.dispose();
  }

  void _hideKeyboard() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter?.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });
          
          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  const SizedBox(height: 32),
                  Headline1(text: I18n.strings.addAccount),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Provider(
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
