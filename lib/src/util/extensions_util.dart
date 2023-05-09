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
}
