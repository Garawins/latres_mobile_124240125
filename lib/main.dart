import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/favorite_spell.dart';
import 'screens/character_list_screen.dart';
import 'screens/login_screen.dart';
import 'services/notification_service.dart';
import 'services/session_service.dart';
import 'utils/snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Penyimpanan lokal Hive untuk spell favorit.
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteSpellAdapter());
  await Hive.openBox<FavoriteSpell>('favorite_spells');

  // Notifikasi lokal (dipakai saat menghapus favorit).
  await initNotifications();

  // Kalau session login masih tersimpan, langsung ke halaman karakter.
  final bool loggedIn = await SessionService.isLoggedIn();

  runApp(MainApp(isLoggedIn: loggedIn));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;

  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: rootMessengerKey,
      title: 'Harry Potter - Latres Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const CharacterListScreen() : const LoginScreen(),
    );
  }
}
