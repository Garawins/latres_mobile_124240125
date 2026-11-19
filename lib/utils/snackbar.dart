import 'package:flutter/material.dart';

/// Kunci messenger di tingkat aplikasi, supaya snackbar tetap tampil
/// walaupun halaman sudah berganti (misalnya setelah login/logout).
final GlobalKey<ScaffoldMessengerState> rootMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void _showAppSnackBar({
  required Color color,
  required String title,
  required String message,
}) {
  rootMessengerKey.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(message),
        ],
      ),
    ),
  );
}

void showSuccessSnackBar(String title, String message) =>
    _showAppSnackBar(color: Colors.green, title: title, message: message);

void showErrorSnackBar(String title, String message) =>
    _showAppSnackBar(color: Colors.red, title: title, message: message);
