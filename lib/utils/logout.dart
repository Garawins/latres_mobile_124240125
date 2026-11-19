import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../services/session_service.dart';
import 'snackbar.dart';

/// Logout yang dipakai bersama di AppBar halaman Characters dan Spells:
/// hapus session, kembali ke halaman login, tampilkan snackbar.
Future<void> handleLogout(BuildContext context) async {
  await SessionService.clearLogin();
  if (!context.mounted) return;
  await Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
    (route) => false,
  );
  showSuccessSnackBar('Success!', 'Logged out Successfully');
}
