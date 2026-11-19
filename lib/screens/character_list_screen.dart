import 'package:flutter/material.dart';

import '../models/character.dart';
import '../services/potter_api.dart';
import '../utils/logout.dart';
import 'character_detail_screen.dart';
import 'spell_list_screen.dart';

/// Halaman Character View: daftar karakter dari API.
/// Tap salah satu item untuk membuka halaman detail.
class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  List<Character> _characters = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  Future<void> _fetchCharacters() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final result = await PotterApi.fetchCharacters();
      if (!mounted) return;
      setState(() {
        _characters = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal mengambil data karakter';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F1F8),
        title: const Text('Harry Potter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => handleLogout(context),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SpellListScreen(),
                ),
              );
            },
            child: const Text('Spells'),
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
              onPressed: _fetchCharacters,
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      itemCount: _characters.length,
      itemBuilder: (context, index) {
        final character = _characters[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: ListTile(
            leading: ClipOval(
              child: Image.network(
                character.image,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => CircleAvatar(
                  child: Text(
                    character.fullName.isNotEmpty ? character.fullName[0] : '?',
                  ),
                ),
              ),
            ),
            title: Text(character.fullName),
            subtitle: Text(character.interpretedBy),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CharacterDetailScreen(character: character),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
