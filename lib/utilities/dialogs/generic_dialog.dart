import 'dart:ui';

import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) async {
  final options = optionBuilder();
  return showDialog<T>(
    context: context,
    builder: ((context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white.withOpacity(0.4),
          title: Text(title),
          content: Text(content),
          actions: options.keys.map((optionTitle) {
            final T value = options[optionTitle];
            return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(optionTitle),
            );
          }).toList(),
        ),
      );
    }),
  );
}
