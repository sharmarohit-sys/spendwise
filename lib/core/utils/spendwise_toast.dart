import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SpendWiseToast {
  static void show({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    int durationInSec = 2,
  }) {
    Fluttertoast.showToast(
      msg: message,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: durationInSec,
      fontSize: 14,
    );
  }

  static void success(String message) =>
      show(message: message, backgroundColor: Colors.green);

  static void error(String message) =>
      show(message: message, backgroundColor: Colors.redAccent);

  static void warning(String message) =>
      show(message: message, backgroundColor: Colors.orange);

  static void info(String message) =>
      show(message: message, backgroundColor: Colors.blueAccent);
}
