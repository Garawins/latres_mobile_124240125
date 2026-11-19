import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/character.dart';
import '../models/spell.dart';

/// Pengambilan data dari Potter API.
class PotterApi {
  static const String _baseUrl = 'https://potterapi-fedeperin.vercel.app/en';

  static Future<List<Character>> fetchCharacters() async {
    final response = await http.get(Uri.parse('$_baseUrl/characters'));
    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil data karakter (HTTP ${response.statusCode})',
      );
    }
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => Character.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Spell>> fetchSpells() async {
    final response = await http.get(Uri.parse('$_baseUrl/spells'));
    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil data spell (HTTP ${response.statusCode})',
      );
    }
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => Spell.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
