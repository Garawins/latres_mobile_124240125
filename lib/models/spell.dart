/// Satu mantra dari API
/// https://potterapi-fedeperin.vercel.app/en/spells
class Spell {
  final String spell;
  final String use;
  final int index;

  const Spell({required this.spell, required this.use, required this.index});

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      spell: json['spell'] as String? ?? '-',
      use: json['use'] as String? ?? '-',
      index: json['index'] as int? ?? 0,
    );
  }
}
