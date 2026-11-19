import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/favorite_spell.dart';
import '../services/notification_service.dart';
import '../utils/snackbar.dart';

/// Halaman Favorite Spells View: daftar mantra yang sudah difavoritkan.
/// Mantra bisa dihapus dari halaman ini; saat dihapus tampil snackbar
/// dan notifikasi langsung (immediate notification).
class FavoriteSpellsScreen extends StatefulWidget {
  const FavoriteSpellsScreen({super.key});

  @override
  State<FavoriteSpellsScreen> createState() => _FavoriteSpellsScreenState();
}

class _FavoriteSpellsScreenState extends State<FavoriteSpellsScreen> {
  late Box<FavoriteSpell> _favoritesBox;

  @override
  void initState() {
    super.initState();
    _favoritesBox = Hive.box<FavoriteSpell>('favorite_spells');
  }

  Future<void> _deleteFavorite(int key, String spellName) async {
    await _favoritesBox.delete(key);
    showErrorSnackBar('Remove!', '$spellName removed from fav list!');
    await showSpellDeletedNotification(spellName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F1F8),
        title: const Text('Favorite Spell'),
      ),
      body: ValueListenableBuilder<Box<FavoriteSpell>>(
        valueListenable: _favoritesBox.listenable(),
        builder: (context, box, child) {
          final favorites = box.values.toList();
          final keys = box.keys.cast<int>().toList();
          if (favorites.isEmpty) {
            return const Center(child: Text('Belum ada spell favorite'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final data = favorites[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(data.spell),
                  subtitle: Text(data.use),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteFavorite(keys[index], data.spell),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
