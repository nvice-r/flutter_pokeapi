import 'package:flutter/material.dart';
import 'package:flutter_pokeapi/domain/local_authenticate_state_notifier.dart';
import 'package:flutter_pokeapi/domain/pokemon_specie_list_notifier.dart';
import 'package:flutter_pokeapi/model/pokemon/specie.dart';
import 'package:flutter_pokeapi/model/progressive_result.dart';
import 'package:flutter_pokeapi/util/widget_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: _loadingProgress()));
  }

  Widget _loadingProgress() {
    return Consumer(builder: (context, ref, child) {
      final isAuthenticated = ref.watch(localAuthenStateNotifierProvider
          .select((data) => data.valueOrNull?.isSuccessful ?? false));

      if (isAuthenticated) {
        ref.listen(
            pokemonSpecieListNotifierProvider.select((value) => value.asError),
            (previous, next) {
          if (next != null &&
              !next.isLoading &&
              !next.isRefreshing &&
              !next.isReloading) {
            final error = next.error as Exception;
            showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) =>
                        _getPokemonListErrorAlert(context, error))
                .then((shouldRefresh) {
              if (shouldRefresh ?? false) {
                ref.invalidate(pokemonSpecieListNotifierProvider);
              }
            });
          }
        });
      }
      return Consumer(builder: (context, ref, child) {
        ProgressiveResult<List<Specie>>? result;
        if (isAuthenticated) {
          result = ref.watch(pokemonSpecieListNotifierProvider
              .select((asyncValue) => asyncValue.value));
        } else {
          doWhenRendered((_) {
            ref
                .read(localAuthenStateNotifierProvider.notifier)
                .authenticateWithBiometrics();
          });
        }
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          tween: Tween<double>(
            begin: 0,
            end: result?.progress ?? 0,
          ),
          builder: (_, value, __) => LinearProgressIndicator(
            value: value,
          ),
        );
      });
    });
  }

  AlertDialog _getPokemonListErrorAlert(BuildContext context, Exception error) {
    return AlertDialog(
      title: const Text('Pokemon List Error'),
      content: Text(error.toString()),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Refresh'),
        ),
      ],
    );
  }
}
