import 'package:json_annotation/json_annotation.dart';

part 'sprites.g.dart';

@JsonSerializable()
class Sprites {
  @JsonKey(name: 'front_default')
  final String? frontDefault;
  final Other? other;

  Sprites({required this.frontDefault, required this.other});

  factory Sprites.fromJson(Map<String, dynamic> json) =>
      _$SpritesFromJson(json);
}

@JsonSerializable()
class Other {
  @JsonKey(name: 'official-artwork')
  final OfficialArtwork? officialArtwork;

  Other({required this.officialArtwork});

  factory Other.fromJson(Map<String, dynamic> json) => _$OtherFromJson(json);
}

@JsonSerializable()
class OfficialArtwork {
  @JsonKey(name: 'front_default')
  final String? frontDefault;

  OfficialArtwork({required this.frontDefault});

  factory OfficialArtwork.fromJson(Map<String, dynamic> json) =>
      _$OfficialArtworkFromJson(json);
}
