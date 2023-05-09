part of craft_dynamic;

class BioMetricUtil {
  static final _sharedPref = CommonSharedPref();

  static Future<bool> biometricAuthenticate() async {
    await _sharedPref.getBio();
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Authenticate using biometrics',
        authMessages: <AuthMessages>[
          AndroidAuthMessages(
              signInTitle: 'Login',
              biometricHint: "Login to your ${APIService.appLabel} account"),
          const IOSAuthMessages(
            cancelButton: 'No thanks',
          ),
        ],
        options: const AuthenticationOptions(biometricOnly: true),
      );
      return didAuthenticate;
    } catch (e) {
      AppLogger.appLogE(tag: "BIOMETRIC ERROR", message: e.toString());
    }
    return false;
  }
}
