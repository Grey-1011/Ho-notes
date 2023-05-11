import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // AppBar(
            //   title: Text(context.loc.verify_email),
            //   backgroundColor: Colors.transparent,
            //   elevation: 0,
            // ),
            const SizedBox(height: 64),
            Center(
              child: SvgPicture.asset(
                'assets/images/verify_email.svg',
                width: 150.0,
                height: 150.0,
              ),
            ),
            RichText(
              text: TextSpan(
                text: context.loc.verify_email,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                text: TextSpan(
                  text: context.loc.verify_email_view_prompt,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read<AuthBloc>()
                    .add(const AuthEventsSendEmailVerification());
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 40.0,
                ), // 按钮内边距
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // 按钮圆角
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                ),
              ),
              child: Text(
                context.loc.verify_email_send_email_verification,
              ),
            ),
            TextButton.icon(
              label: Text(
                context.loc.restart,
              ),
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
            )
          ],
        ),
      ),
    );
  }
}
