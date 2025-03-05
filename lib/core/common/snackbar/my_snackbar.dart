import 'package:flutter/material.dart';

void showMySnackBar({
  required BuildContext context,
  required String message,
   Color? color,
  int seconds = 3, // Default duration in seconds
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color,
      duration: Duration(seconds: seconds), // Uses seconds, not duration directly
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}