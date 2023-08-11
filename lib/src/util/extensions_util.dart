part of craft_dynamic;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension StringCapitalization on String {
  String capitalizeWords() {
    var words = split(" ");
    var capitalizedWords =
        words.map((word) => word[0].toUpperCase() + word.substring(1));
    return capitalizedWords.join(" ");
  }
}

extension ModuleIdExt on ModuleId {
  String get name => describeEnum(this);
}

extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension FormatPhone on String {
  String formatPhone() {
    return replaceAll(RegExp('[^0-9]'), '');
  }

  String capitalizeFirstLetter() =>
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
}

extension APICall on APIService {
  Future<DynamicResponse?> getDynamicDropDownValues(
      String actionID, ModuleItem moduleItem) async {
    var request = await dioRequestBodySetUp("DBCALL", objectMap: {
      "MerchantID": moduleItem.merchantID,
      "DynamicForm": {"HEADER": actionID, "MerchantID": moduleItem.merchantID}
    });
    final route = await _sharedPref.getRoute("other".toLowerCase());
    var response = await performDioRequest(request, route: route);
    AppLogger.appLogI(tag: "dynamic dropdown", message: "data::$response");
    return DynamicResponse.fromJson(jsonDecode(response ?? "{}"));
  }

  Future<DynamicResponse?> getDynamicLink(
      String actionID, ModuleItem moduleItem) async {
    var request = await dioRequestBodySetUp("DBCALL", objectMap: {
      "MerchantID": moduleItem.merchantID,
      "DynamicForm": {"HEADER": actionID, "MerchantID": moduleItem.merchantID}
    });
    final route = await _sharedPref.getRoute("other".toLowerCase());
    var response = await performDioRequest(request, route: route);
    AppLogger.appLogI(tag: "dynamic link", message: "data::$response");
    return DynamicResponse.fromJson(jsonDecode(response ?? "{}"));
  }
}

extension Navigate on BuildContext {
  navigate(Widget widget) {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  navigateAndPopAll(Widget widget) {
    Navigator.pushAndRemoveUntil(this,
        MaterialPageRoute(builder: (context) => widget), (route) => false);
  }

  remove() {
    Navigator.of(this).pop();
  }
}
