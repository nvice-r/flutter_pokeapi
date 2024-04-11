import 'package:flutter_pokeapi/data/pokemon_repository.dart';
import 'package:flutter_pokeapi/model/pokemon/specie.dart';
import 'package:flutter_pokeapi/model/progressive_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_specie_list_notifier.g.dart';

@riverpod
class PokemonSpecieListNotifier extends _$PokemonSpecieListNotifier {
  @override
  Stream<ProgressiveResult<List<Specie>>> build() {
    return ref
        .read(pokemonRepositoryProvider)
        .fetchPokemonSpecieList()
        .handleError((error) => state = AsyncError(error, StackTrace.current));
  }
}
