import 'package:flutter_pokeapi/network/pokemon_service.dart';
import 'package:flutter_pokeapi/provider/network_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_providers.g.dart';

@riverpod
PokemonService pokemonService(PokemonServiceRef ref) {
  final dio = ref.read(dioProvider);
  return PokemonService(dio);
}
