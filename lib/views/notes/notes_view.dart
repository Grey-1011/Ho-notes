import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF080808),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: StreamBuilder(
                stream: _notesService.allNotes(ownerUserId: userId).getLength,
                builder: (context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    final noteCount = snapshot.data ?? 0;
                    final text = context.loc.notes_title(noteCount);
                    return Text(text);
                  } else {
                    return const Text('');
                  }
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    if (mounted) {
                      Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
                PopupMenuButton<MenuAction>(
                  color: Colors.white.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  icon: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.4),
                    ),
                    child: const Icon(Icons.menu),
                  ),
                  iconSize: 20,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<MenuAction>>[
                    PopupMenuItem(
                      value: MenuAction.logout,
                      child: Text(
                        context.loc.logout_button,
                      ),
                    )
                  ],
                  onSelected: (MenuAction result) async {
                    switch (result) {
                      case MenuAction.logout:
                        final shouldLogout = await showLogOutDialog(context);
                        if (shouldLogout) {
                          if (mounted) {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventLogOut());
                          }
                        }
                        break;
                      default:
                        break;
                    }
                  },
                )
              ],
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: StreamBuilder(
                    stream: _notesService.allNotes(ownerUserId: userId),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final allNotes =
                                snapshot.data as Iterable<CloudNote>;
                            return NotesListView(
                              notes: allNotes,
                              onDeleteNote: (note) async {
                                await _notesService.deleteNote(
                                    documentId: note.documentId);
                              },
                              onTap: (note) {
                                Navigator.of(context).pushNamed(
                                  createOrUpdateNoteRoute,
                                  arguments: note,
                                );
                              },
                            );
                          } else {
                            return const SizedBox(
                              width: 100,
                              height: 100,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        default:
                          return const SizedBox(
                            width: 100,
                            height: 100,
                            child: Center(child: CircularProgressIndicator()),
                          );
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
