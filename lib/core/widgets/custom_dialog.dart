import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showCustomDialog(
    {required String descriptionText,
    required String title,
    required Function() onPressedOK,
    required String buttonTextOK,
    required Function() onPressedCancel,
    required String buttonTextCancel,
    required BuildContext context}) async {
  await showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
            title: Text(title),
            content: Text(descriptionText),
            actions: [
              adaptiveAction(
                context: context,
                onPressed: onPressedOK,
                child: Text(
                  buttonTextOK,
                ),
              ),
              adaptiveAction(
                context: context,
                onPressed: onPressedCancel,
                child: Text(
                  buttonTextCancel,
                ),
              )
            ],
          ));
}

Widget adaptiveAction(
    {required BuildContext context,
    required VoidCallback onPressed,
    required Widget child}) {
  final ThemeData theme = Theme.of(context);
  switch (theme.platform) {
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      return TextButton(onPressed: onPressed, child: child);
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return CupertinoDialogAction(onPressed: onPressed, child: child);
  }
}
