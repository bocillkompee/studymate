import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String cancelLabel = 'Batal',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      void close(bool value) => Navigator.of(dialogContext).pop(value);

      return Shortcuts(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (_) {
                close(false);
                return null;
              },
            ),
          },
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () => close(false),
                child: Text(cancelLabel),
              ),
              FilledButton(
                onPressed: () => close(true),
                style: destructive
                    ? FilledButton.styleFrom(
                        backgroundColor: AppColors.danger,
                        foregroundColor: Colors.white,
                      )
                    : null,
                child: Text(confirmLabel),
              ),
            ],
          ),
        ),
      );
    },
  );

  return result ?? false;
}
