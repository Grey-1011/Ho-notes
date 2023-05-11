import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/dialogs/password_rest_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordRestSendDialog(context);
          } else if (state.exception != null) {
            await showErrorDialog(
                context, context.loc.forgot_password_view_generic_error);
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
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  context.loc.forgot_password,
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(context.loc.forgot_password_view_prompt),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        autofocus: true,
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: context.loc.email_text_field_placeholder,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          final email = _controller.text;
                          context
                              .read<AuthBloc>()
                              .add(AuthEventForgotPassword(email: email));
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14.0,
                            horizontal: 40.0,
                          ), // 按钮内边距
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // 按钮圆角
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        child:
                            Text(context.loc.forgot_password_view_send_me_link),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(const AuthEventLogOut());
                        },
                        child: Text(
                            context.loc.forgot_password_view_back_to_login),
                      )
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
