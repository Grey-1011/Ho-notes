import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
                context, context.loc.register_error_weak_password);
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
                context, context.loc.register_error_email_already_in_use);
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
                context, context.loc.register_error_invalid_email);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, context.loc.register_error_generic);
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
          child: Column(
            children: [
              AppBar(
                title: Text(
                  context.loc.register,
                  style: Theme.of(context).textTheme.headline1,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.loc.register_view_prompt,
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        autofocus: true,
                        controller: _email,
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: context.loc.email_text_field_placeholder,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            gapPadding: 40.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        autofocus: true,
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: context.loc.password_text_field_placeholder,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            gapPadding: 40.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48.0),
                      Center(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final email = _email.text;
                                final password = _password.text;
                                context
                                    .read<AuthBloc>()
                                    .add(AuthEventRegister(email, password));
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 72.0,
                                ), // 按钮内边距
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(20.0), // 按钮圆角
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              child: Text(
                                context.loc.register,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(const AuthEventLogOut());
                              },
                              child: Text(
                                context.loc.register_view_already_registered,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
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
