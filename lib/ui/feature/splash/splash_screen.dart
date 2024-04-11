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
            child: _loadingProgress(context)));
  }

  Widget _loadingProgress(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final isAuthenticated =
          ref.watch(localAuthenStateNotifierProvider).value?.isSuccessful ??
              false;
      ProgressiveResult<List<Specie>>? result;

      if (isAuthenticated) {
        ref.watch(pokemonSpecieListNotifierProvider).whenOrNull(
            data: (data) => result = data,
            error: (error, stackTrace) => doWhenRendered((_) async {
                  final shouldRefresh = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) =>
                              _getPokemonListErrorAlert(context, error)) ??
                      false;
                  if (shouldRefresh) {
                    ref.invalidate(pokemonSpecieListNotifierProvider);
                  }
                }));
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
        builder: (context, value, _) => LinearProgressIndicator(
          value: value,
        ),
      );
    });
  }

  AlertDialog _getPokemonListErrorAlert(BuildContext context, Object error) {
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
