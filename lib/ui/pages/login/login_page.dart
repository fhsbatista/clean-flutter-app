import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';
import '../../components/components.dart';
import 'components/components.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;

  LoginPage(this.presenter);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          widget.presenter?.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          widget.presenter?.mainErrorStream.listen((error) {
            if (error != null) {
              showErrorMessage(context, error);
            }
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                const SizedBox(height: 32),
                Headline1(text: 'Login'),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Provider(
                    create: (_) => widget.presenter,
                    child: Form(
                      child: Column(
                        children: [
                          EmailInput(),
                          const SizedBox(height: 8),
                          StreamBuilder<String?>(
                              stream: widget.presenter?.passwordErrorStream,
                              builder: (context, snapshot) {
                                return TextFormField(
                                  onChanged: widget.presenter?.validatePassword,
                                  decoration: InputDecoration(
                                    labelText: 'senha',
                                    errorText: snapshot.data?.isEmpty == true
                                        ? null
                                        : snapshot.data,
                                    icon: Icon(
                                      Icons.lock,
                                      color: Theme.of(context).primaryColorLight,
                                    ),
                                  ),
                                  obscureText: true,
                                );
                              }),
                          const SizedBox(height: 32),
                          StreamBuilder<bool>(
                              stream: widget.presenter?.isFormValidStream,
                              builder: (context, snapshot) {
                                return ElevatedButton(
                                  onPressed: snapshot.data == true
                                      ? widget.presenter?.auth
                                      : null,
                                  child: Text('Entrar'.toUpperCase()),
                                );
                              }),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.person),
                            label: Text('Criar conta'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}


