import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/favorite_spell.dart';
import '../models/spell.dart';
import '../services/potter_api.dart';
import '../utils/logout.dart';
import '../utils/snackbar.dart';
import 'character_list_screen.dart';
import 'favorite_spells_screen.dart';

/// Halaman Spells View: daftar mantra dari API.
/// Tombol hati menambah/menghapus mantra dari favorit (Hive),
/// lengkap dengan snackbar seperti contoh. FAB hati membuka
/// halaman Favorite Spell.
class SpellListScreen extends StatefulWidget {
  const SpellListScreen({super.key});

  @override
  State<SpellListScreen> createState() => _SpellListScreenState();
}

class _SpellListScreenState extends State<SpellListScreen> {
  List<Spell> _spells = [];
  bool _isLoading = true;
  String _error = '';
  late Box<FavoriteSpell> _favoritesBox;

  @override
  void initState() {
    super.initState();
    _favoritesBox = Hive.box<FavoriteSpell>('favorite_spells');
    _fetchSpells();
  }

  Future<void> _fetchSpells() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final result = await PotterApi.fetchSpells();
      if (!mounted) return;
      setState(() {
        _spells = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal mengambil data spell';
        _isLoading = false;
      });
    }
  }

  bool _isFavorite(Spell spell) => _favoritesBox.containsKey(spell.index);

  Future<void> _toggleFavorite(Spell spell) async {
    if (_isFavorite(spell)) {
      await _favoritesBox.delete(spell.index);
      showErrorSnackBar('Remove!', '${spell.spell} removed from fav list!');
    } else {
      await _favoritesBox.put(
        spell.index,
        FavoriteSpell(spell: spell.spell, use: spell.use, index: spell.index),
      );
      showSuccessSnackBar(
        'Add!',
        '${spell.spell} successfully added to fav list!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F1F8),
        title: const Text('Harry Potter Spells Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => handleLogout(context),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE8D9F5),
        tooltip: 'Favorite Spell',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FavoriteSpellsScreen(),
            ),
          );
        },
        child: const Icon(Icons.favorite, color: Colors.red),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CharacterListScreen(),
                ),
              );
            },
            child: const Text('Characters'),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchSpells,
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      );
    }
    // Daftar ikut berubah otomatis saat isi box Hive berubah.
    return ValueListenableBuilder<Box<FavoriteSpell>>(
      valueListenable: _favoritesBox.listenable(),
      builder: (context, box, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          itemCount: _spells.length,
          itemBuilder: (context, index) {
            final spell = _spells[index];
            final isFavorite = box.containsKey(spell.index);
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: ListTile(
                leading: const Icon(Icons.menu_book),
                title: Text(spell.spell),
                subtitle: Text(spell.use),
                trailing: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.black87,
                  ),
                  onPressed: () => _toggleFavorite(spell),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
