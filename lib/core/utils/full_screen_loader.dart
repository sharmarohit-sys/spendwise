import 'package:flutter/material.dart';

class FullScreenLoader {
  static bool _isShowing = false;

  /// Show the loading dialog
  static void show(BuildContext context, {String? message}) {
    if (_isShowing) return; // Prevent multiple dialogs

    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false, // prevent back button dismissal
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Hide the loading dialog
  static void hide(BuildContext context) {
    if (!_isShowing) return;

    _isShowing = false;
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
