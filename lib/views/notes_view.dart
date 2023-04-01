import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../constants/routes.dart';
import '../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}


class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuAction>>[
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
                    await AuthService.firebase().logOut();
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (route) => false,
                      );
                    }
                  }
                  break;
                default:
                  break;
              }
            },
          ),
        ],
      ),
      body: const Text('Hello World'),
    );
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
              child: const Text('Log out'),
            )
          ],
        );
      })).then((value) => value ?? false);
}
