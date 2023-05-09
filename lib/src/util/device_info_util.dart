part of craft_dynamic;

class DeviceInfo {
  static getDeviceUniqueID() async {
    if (kIsWeb) {
      return html.window.navigator.userAgent.split(' ')[0];
    }
    return await UniqueIdentifier.serial;
  }

  static performDeviceSecurityScan() async {
    if (await _checkDeviceRooted()) {
      Future.delayed(const Duration(seconds: 10), () {
        Fluttertoast.showToast(
            msg: "This app cannot work on rooted device!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        exit(0);
      });
    }
  }

  static Future<bool> _checkDeviceRooted() async {
    bool jailBroken = false;
    try {
      jailBroken = await FlutterJailbreakDetection.jailbroken;
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
