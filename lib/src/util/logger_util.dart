part of craft_dynamic;

class AppLogger {
  static Logger logger = Logger();

  static appLogD({required tag, required message}) {
    if (kDebugMode) {
      logger.d("$tag: $message");
    }
  }

  static appLogI({required tag, required message}) {
    if (kDebugMode) {
      logger.i("$tag: $message");
    }
  }

  static appLogE({required tag, required message}) {
    if (kDebugMode) {
      logger.e("$tag: $message");
    }
  }

  static writeResponseToFile({required fileName, required response}) {
    if (kDebugMode && !kIsWeb) {
      FileOperations().writeFile(fileName, response);
    }
  }
}

class FileOperations {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> getLocalFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName.txt');
  }

  writeFile(String fileName, String response) async {
    final file = getLocalFile(fileName);
    file.then((file) => {
          AppLogger.appLogE(tag: "App Logger", message: "File is writing"),
          file.writeAsString(response)
        });
  }
}
