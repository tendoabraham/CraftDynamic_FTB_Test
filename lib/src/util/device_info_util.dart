part of craft_dynamic;

class DeviceInfo {
  static getDeviceUniqueID() async {
    if (kIsWeb) {
      return "123";
    }

    if (Platform.isAndroid) {
      return await UniqueIdentifier.serial;
    } else if (Platform.isIOS) {
      return generateRandomString(10);
    }
    // return await UniqueIdentifier.serial;
  }

  static String generateRandomString(int length) {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }

  static performDeviceSecurityScan() async {
    if (await _checkDeviceRooted()) {
      Fluttertoast.showToast(
          msg: "This app cannot work on rooted device!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Future.delayed(const Duration(seconds: 5), () {
        exit(0);
      });
    }
  }

  static Future<bool> _checkDeviceRooted() async {
    bool jailBroken = false;
    try {
      jailBroken = await RootChecker.isDeviceRooted();
      AppLogger.appLogD(tag: "check device rooted status", message: jailBroken);
    } on PlatformException {
      jailBroken = true;
    }
    return jailBroken;
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
