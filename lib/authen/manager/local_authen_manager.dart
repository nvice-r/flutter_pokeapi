import 'package:local_auth/local_auth.dart';

class LocalAuthenManager {
  final _localAuth = LocalAuthentication();
  static final LocalAuthenManager _instance = LocalAuthenManager._internal();
  factory LocalAuthenManager() => _instance;
  LocalAuthenManager._internal();

  final _allowedBiometrics = <BiometricType>[
    BiometricType.face,
    BiometricType.fingerprint,
    BiometricType.strong
  ];
  final _availableBiometrics = <BiometricType>[];

  Future<bool> authenticate() {
    return _localAuth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(stickyAuth: true));
  }

  Future<bool> authenticateWithBiometrics() async {
    if (await canAuthenticate()) {
      return await _localAuth.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate',
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: true));
    } else {
      throw Exception('No biometrics available');
    }
  }

  Future<bool> canAuthenticate() async {
    final availableBiometrics = await getAvailableBiometrics();
    return (await _localAuth.canCheckBiometrics ||
            await _localAuth.isDeviceSupported()) &&
        (availableBiometrics.isNotEmpty &&
            availableBiometrics
                .where((type) => _allowedBiometrics.contains(type))
                .isNotEmpty);
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    if (_availableBiometrics.isEmpty) {
      _availableBiometrics.addAll(await _localAuth.getAvailableBiometrics());
    }
    return _availableBiometrics;
  }
}
