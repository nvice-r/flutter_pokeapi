import 'package:flutter_pokeapi/model/paging/paging.dart';
import 'package:flutter_pokeapi/model/pokemon/specie.dart';
import 'package:json_annotation/json_annotation.dart';

part 'specie_paging.g.dart';

@JsonSerializable()
class SpeciePaging extends Paging<Specie> {
  SpeciePaging(
      {required super.count,
      required super.results,
      required super.next,
      required super.previous});

  factory SpeciePaging.fromJson(Map<String, dynamic> json) =>
      _$SpeciePagingFromJson(json);
}
