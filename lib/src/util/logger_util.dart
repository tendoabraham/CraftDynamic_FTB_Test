import 'dart:io';

import 'package:flutter/foundation.dart' hide Key;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class AppLogger {
  static Logger logger = Logger();

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
    file.then((file) =>
        {debugPrint("Writing $file..."), file.writeAsString(response)});
  }
}
