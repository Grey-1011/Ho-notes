import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/notes/': (context) => const NotesView(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                // Already VerifyEmail
                return const NotesView();
              } else {
                // go VerifyEmail
                return const VerifyEmailView();
              }
            } else {
              // user == null,  go Login
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

enum MenuAction { edit, delete, share, logout }

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main UI'),
          actions: [
            PopupMenuButton<MenuAction>(
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<MenuAction>>[
                      const PopupMenuItem(
                        value: MenuAction.edit,
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: MenuAction.delete,
                        child: Text('Delete'),
                      ),
                      const PopupMenuItem(
                        value: MenuAction.share,
                        child: Text('Share'),
                      ),
                      const PopupMenuItem(
                        value: MenuAction.logout,
                        child: Text('Log out'),
                      )
                    ],
                onSelected: (MenuAction result) async {
                  switch (result) {
                    case MenuAction.edit:
                      break;
                    case MenuAction.delete:
                      break;
                    case MenuAction.share:
                      break;
                    case MenuAction.logout:
                      final shouldLogout = await showLogOutDialog(context);
                      if (shouldLogout) {
                        await FirebaseAuth.instance.signOut();
                        if (mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login/',
                            (route) => false,
                          );
                        }
                      }
                      break;
                    default:
                      break;
                  }
                }),
          ],
        ),
        body: const Text('Hello World'));
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Log out'))
          ],
        );
      })).then((value) => value ?? false);
}
