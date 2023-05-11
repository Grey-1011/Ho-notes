import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';
import 'package:mynotes/utilities/generics/get_random_color.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return Container(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: getRandomColor(),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
              style: ListTileStyle.drawer,
              title: Text(
                note.text,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                onTap(note);
              },
              trailing: IconButton(
                onPressed: () async {
                  final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
                },
                icon: const Icon(Icons.delete),
              ),
            ),
          ),
        );
      },
    );
  }
}
