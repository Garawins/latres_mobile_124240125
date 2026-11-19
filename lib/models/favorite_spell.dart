import 'package:hive/hive.dart';

/// Mantra favorit yang disimpan di Hive (box 'favorite_spells',
/// kunci = [index] mantra dari API).
///
/// Adapter ditulis manual di file ini (tanpa code generation),
/// supaya tidak bergantung pada `build_runner`.
@HiveType(typeId: 0)
class FavoriteSpell extends HiveObject {
  @HiveField(0)
  String spell;

  @HiveField(1)
  String use;

  @HiveField(2)
  int index;

  FavoriteSpell({required this.spell, required this.use, required this.index});
}

class FavoriteSpellAdapter extends TypeAdapter<FavoriteSpell> {
  @override
  final int typeId = 0;

  @override
  FavoriteSpell read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteSpell(
      spell: fields[0] as String,
      use: fields[1] as String,
      index: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteSpell obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.spell)
      ..writeByte(1)
      ..write(obj.use)
      ..writeByte(2)
      ..write(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteSpellAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
