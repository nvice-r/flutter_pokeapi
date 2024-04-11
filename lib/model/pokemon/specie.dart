import 'package:json_annotation/json_annotation.dart';

part 'specie.g.dart';

@JsonSerializable()
class Specie {
  final String? name;
  final String? url;

  Specie({required this.name, required this.url});

  factory Specie.fromJson(Map<String, dynamic> json) => _$SpecieFromJson(json);
}
