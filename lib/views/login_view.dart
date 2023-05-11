import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

import '../extensions/buildcontext/loc.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              context.loc.login_error_cannot_find_user,
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
                context, context.loc.login_error_wrong_credentials);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, context.loc.login_error_auth_error);
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue,
                Colors.purple,
              ],
            ),
          ),
          // color: const Color(0xFFf9fbfc),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  context.loc.login,
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          context.loc.login_view_prompt,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 16,
                          ),
                          child: TextField(
                            controller: _email,
                            autocorrect: false,
                            enableSuggestions: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText:
                                  context.loc.email_text_field_placeholder,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                gapPadding: 40.0,
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          controller: _password,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText:
                                context.loc.password_text_field_placeholder,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              gapPadding: 40.0,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add(const AuthEventForgotPassword());
                            },
                            child: Text(
                              context.loc.login_view_forgot_password,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            final loadingText =
                                context.loc.login_view_loading_text;
                            context.read<AuthBloc>().add(
                                AuthEventLogin(email, password, loadingText));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 72.0,
                            ), // 按钮内边距
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0), // 按钮圆角
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          child: Text(
                            context.loc.login,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventShouldRegister());
                          },
                          child: Text(
                            context.loc.login_view_not_registered_yet,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
