import 'package:flutter_pokeapi/authen/manager/local_authen_manager.dart';
import 'package:flutter_pokeapi/authen/local_authen_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_authenticate_state_notifier.g.dart';

@riverpod
class LocalAuthenStateNotifier extends _$LocalAuthenStateNotifier {
  final _authenManager = LocalAuthenManager();

  @override
  LocalAuthenState build() {
    return const LocalAuthenState();
  }

  Future<void> authenticate() async {
    await _authenManager.authenticate().then((isSuccessful) {
      state = AsyncData(LocalAuthenState(isSuccessful: isSuccessful));
    }, onError: (error) {
      state = AsyncError(error, StackTrace.current);
    });
  }

  Future<void> authenticateWithBiometrics() async {
    await _authenManager.authenticateWithBiometrics().then((isSuccessful) {
      state = AsyncData(LocalAuthenState(isSuccessful: isSuccessful));
    }, onError: (error) {
      authenticate();
    });
  }
}
