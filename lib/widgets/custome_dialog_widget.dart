import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:submission_proyek3/common/navigator.dart';

customeDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  defaultTargetPlatform == TargetPlatform.iOS
      ? showCupertinoDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Ok'),
                  onPressed: () => Navigation.back(),
                ),
              ],
            );
          },
        )
      : showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigation.back(),
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
}
