import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeBinder {
  static const platform = MethodChannel('craft_dynamic');

  static Future<void> invokeMethod(String littleProduct) async {
    await platform.invokeMethod('getLittleProduct', <String, dynamic>{
      'littleProduct': littleProduct,
    });
  }

  // This native method invoke no longer in use
  static Future<String?> rsaEncrypt(String plainText, String publicKey) async {
    debugPrint("Starting rsa encrypt....");
    try {
      String encryptedString = await platform.invokeMethod('encrypt',
          <String, dynamic>{'plainText': plainText, 'publicKey': publicKey});
      debugPrint("Encrypted string:::$encryptedString");
      return encryptedString;
    } catch (e) {
      debugPrint("Invoke method error:::$e");
      return null;
    }
  }

  // This native method invoke no longer in use
  static Future<String?> gcmDecrypt(
      String encryptedString, String iv, String key) async {
    try {
      String decryptedString = await platform.invokeMethod(
          'decrypt', <String, dynamic>{
        'encryptedText': encryptedString,
        'iv': iv,
        'key': key
      });
      debugPrint("Encrypted string:::$encryptedString");
      return decryptedString;
    } catch (e) {
      debugPrint("Invoke method error:::$e");
      return null;
    }
  }
}
