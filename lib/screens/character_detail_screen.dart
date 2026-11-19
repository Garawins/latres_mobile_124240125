import 'package:flutter/material.dart';

import '../models/character.dart';

/// Halaman detail karakter: menampilkan semua property karakter.
class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final childrenText = character.children.isEmpty
        ? '-'
        : character.children.join(', ');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F1F8),
        title: Text(character.fullName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  character.image,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 120, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              _buildData('Full Name', character.fullName),
              _buildData('Nickname', character.nickname),
              _buildData('Hogwarts House', character.hogwartsHouse),
              _buildData('Interpreted By', character.interpretedBy),
              _buildData('Birthdate', character.birthdate),
              _buildData('Children', childrenText),
              _buildData('Index', character.index.toString()),
              _buildData('Image', character.image),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildData(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
