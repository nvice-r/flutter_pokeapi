import 'package:flutter_pokeapi/model/paging/paging.dart';
import 'package:flutter_pokeapi/model/pokemon/pokemon.dart';
import 'package:flutter_pokeapi/model/pokemon/specie.dart';
import 'package:flutter_pokeapi/model/progressive_result.dart';
import 'package:flutter_pokeapi/network/pokemon_service.dart';
import 'package:flutter_pokeapi/provider/service_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_repository.g.dart';

abstract class PokemonRepository {
  Future<Pokemon> getPokemonByName(String name);
  Future<List<Specie>> getPokemonSpecieList();
  bool hasPokemonSpecieListFetched();
  Stream<ProgressiveResult<List<Specie>>> fetchPokemonSpecieList();
}

class DefaultPokemonRepository implements PokemonRepository {
  final PokemonService _api;
  DefaultPokemonRepository(this._api);

  List<Specie> _specieList = List.empty();
  int _specieOffset = 0;

  @override
  Future<Pokemon> getPokemonByName(String name) async {
    return _api.getPokemonAsync(name);
  }

  @override
  Future<List<Specie>> getPokemonSpecieList() async {
    return _specieList;
  }

  @override
  bool hasPokemonSpecieListFetched() {
    return _specieList.isNotEmpty;
  }

  @override
  Stream<ProgressiveResult<List<Specie>>> fetchPokemonSpecieList() async* {
    const limit = 50;
    bool hasNext = true;
    double progress = 0.0;
    while (hasNext) {
      final paging = await _api.getPokemonSpecieListAsync(_specieOffset, limit);
      if (!paging.hasNext()) {
        hasNext = false;
        _specieOffset += paging.results.length;
      } else {
        _specieOffset += limit;
      }
      final count = paging.count;
      if (count == null) throw Exception('unexpected progress');

      final data = paging.results;
      if (!paging.hasPrevious() && _specieList.isNotEmpty) {
        _specieList.clear();
      }
      _specieList += data;

      progress = _specieList.length / count;
      if (progress >= 0.5) throw Exception('force error at the half');
      yield ProgressiveResult(progress: progress, data: data);
    }
  }
}

@Riverpod(keepAlive: true)
PokemonRepository pokemonRepository(PokemonRepositoryRef ref) {
  return DefaultPokemonRepository(ref.read(pokemonServiceProvider));
}
