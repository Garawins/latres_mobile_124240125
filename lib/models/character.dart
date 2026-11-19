/// Satu karakter Harry Potter dari API
/// https://potterapi-fedeperin.vercel.app/en/characters
class Character {
  final String fullName;
  final String nickname;
  final String hogwartsHouse;
  final String interpretedBy;
  final List<String> children;
  final String image;
  final String birthdate;
  final int index;

  const Character({
    required this.fullName,
    required this.nickname,
    required this.hogwartsHouse,
    required this.interpretedBy,
    required this.children,
    required this.image,
    required this.birthdate,
    required this.index,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'];
    return Character(
      fullName: json['fullName'] as String? ?? '-',
      nickname: json['nickname'] as String? ?? '-',
      hogwartsHouse: json['hogwartsHouse'] as String? ?? '-',
      interpretedBy: json['interpretedBy'] as String? ?? '-',
      children: rawChildren is List
          ? rawChildren.map((e) => e.toString()).toList()
          : const [],
      image: json['image'] as String? ?? '',
      birthdate: json['birthdate'] as String? ?? '-',
      index: json['index'] as int? ?? 0,
    );
  }
}
