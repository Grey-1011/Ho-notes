import 'package:flutter/material.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;
  // late final QuillController _textController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    // _textController = QuillController.basic();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      text: text,
      documentId: note.documentId,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;

      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (text.isNotEmpty && note != null) {
      await _notesService.updateNote(
        text: text,
        documentId: note.documentId,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xffcdeff1),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                context.loc.note,
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    final text = _textController.text;
                    if (_note == null || text.isEmpty) {
                      await showCannotShareEmptyNoteDialog(context);
                    } else {
                      Share.share(text);
                    }
                  },
                  icon: const Icon(Icons.share),
                )
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: createOrGetExistingNote(context),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      // _note = snapshot.data as DatabaseNote;
                      _setupTextControllerListener();
                      return Column(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              expands: true, // 设置为true，文本编辑器将自动调整高度以适应内容
                              focusNode: FocusNode(),
                              readOnly: false, // 设置为true，文本编辑器将为只读模式
                              scrollController: ScrollController(),
                             
                              toolbarOptions: const ToolbarOptions(
                                selectAll: true,
                                copy: true,
                                cut: true,
                                paste: true,
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: context.loc.start_typing_your_note,
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  textBaseline: TextBaseline.ideographic,
                                ),
                            
                                contentPadding: const EdgeInsets.all(10.0),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      );
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
          ],
        ),
      ),
    );
  }
}
