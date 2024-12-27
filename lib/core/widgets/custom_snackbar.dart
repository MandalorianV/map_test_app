import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

List<ToastificationItem> toastificationList = <ToastificationItem>[];

void customSnackBar({
  BuildContext? context,
  required String text,
  required Color color,
  Function()? onPressed,
  DismissDirection? dismissDirection,
  String? buttonText,
  Duration? duration,
  String? title,
}) async {
  if (toastificationList.length > 1) {
    toastification.dismiss(toastificationList[0]);
    toastificationList.removeAt(0);
  }
  toastificationList.add(
    toastification.showCustom(
      builder: (
        BuildContext context,
        ToastificationItem holder,
      ) =>
          Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        constraints: BoxConstraints(minHeight: 20),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title is! String
                      ? SizedBox()
                      : Text(title ?? "",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                  title is! String ? SizedBox() : const SizedBox(height: 8),
                  Text(text, style: TextStyle(color: Colors.black)),
                  title is! String ? SizedBox() : const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      autoCloseDuration: const Duration(seconds: 2),
      /*  title: title.isNotEmpty ? Text(title) : null, */
      // you can also use RichText widget for title and description parameters
      dismissDirection: dismissDirection,

      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (
        BuildContext context,
        Animation<double> animation,
        Alignment alignment,
        Widget child,
      ) =>
          FadeTransition(
        opacity: animation,
        child: child,
      ),
    ),
  );
}
