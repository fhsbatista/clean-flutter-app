import 'package:flutter/material.dart';

import '../pages.dart';
import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter? presenter;

  LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginHeader(),
            const SizedBox(height: 32),
            Headline1(text: 'Login'),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                child: Column(
                  children: [
                    StreamBuilder<String?>(
                      stream: presenter?.emailErrorStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          onChanged: presenter?.validateEmail,
                          decoration: InputDecoration(
                            labelText: 'email',
                            errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
                            icon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        );
                      }
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder<String?>(
                      stream: presenter?.passwordErrorStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          onChanged: presenter?.validatePassword,
                          decoration: InputDecoration(
                            labelText: 'senha',
                            errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
                            icon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                          obscureText: true,
                        );
                      }
                    ),
                    const SizedBox(height: 32),
                    StreamBuilder<bool>(
                      stream: presenter?.isFormValidStream,
                      builder: (context, snapshot) {
                        return ElevatedButton(
                          onPressed: snapshot.data == true ? () {} : null,
                          child: Text('Entrar'.toUpperCase()),
                        );
                      }
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.person),
                      label: Text('Criar conta'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
