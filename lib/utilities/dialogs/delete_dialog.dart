import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure want to delete this item',
    optionBuilder: () => {
      'Delete': true,
      'Cancel': false,
    },
  ).then((value) => value ?? false);
}
