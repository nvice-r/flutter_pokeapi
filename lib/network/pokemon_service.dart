import 'package:flutter_pokeapi/model/pokemon/pokemon.dart';
import 'package:flutter_pokeapi/model/paging/specie_paging.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'pokemon_service.g.dart';

@RestApi()
abstract class PokemonService {
  factory PokemonService(Dio dio, {String baseUrl}) = _PokemonService;

  @GET("pokemon/{name}")
  Future<Pokemon> getPokemonAsync(@Path() name);

  @GET("pokemon")
  Future<SpeciePaging> getPokemonSpecieListAsync(
      @Query('offset') int offset, @Query('limit') int limit);
}
