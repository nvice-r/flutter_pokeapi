import 'package:json_annotation/json_annotation.dart';

import 'sprites.dart';

part 'pokemon.g.dart';

@JsonSerializable()
class Pokemon {
  final String? name;
  final Sprites? sprites;

  Pokemon({required this.name, required this.sprites});

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);
}
