// ignore_for_file: depend_on_referenced_packages

library craft_dynamic;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:craft_dynamic/src/builder/request_builder.dart';
import 'package:craft_dynamic/src/network/dynamic_request.dart';
import 'package:craft_dynamic/src/util/config_util.dart';
import 'package:craft_dynamic/src/util/location_util.dart';
import 'package:craft_dynamic/src/util/permissions_util.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' hide Key;
import 'package:flutter/material.dart' hide Key, Table;
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:local_session_timeout/local_session_timeout.dart'
    hide SessionTimeoutState, SessionTimeoutManager;

// import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:logger/logger.dart';
import 'package:archive/archive.dart';
import 'package:encrypt/encrypt.dart' as encryptcrpto hide SecureRandom;
import 'package:crypto/crypto.dart';
import 'package:package_info/package_info.dart';
import 'package:pem/pem.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/gcm.dart';
import 'package:pointycastle/pointycastle.dart';
import "package:hex/hex.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';
import 'package:yaml/yaml.dart';
import 'package:easy_localization/easy_localization.dart';

import 'dynamic_widget.dart';
import 'src/app_data/constants.dart';
import 'src/network/api_util.dart';
import 'src/network/connectivity_plus.dart';
import 'src/network/network_repository.dart';
import 'src/network/rsa_util.dart';
import 'src/session_manager/session_manager.dart';
import 'src/state/plugin_state.dart';
import 'src/ui/dynamic_components.dart';
import 'src/util/logger_util.dart';

part 'src/app_data/model.dart';

part 'src/app_data/entity.dart';

part 'src/app_data/enums.dart';

part 'src/app_data/shared_pref.dart';

part 'src/network/api_service.dart';

part 'src/util/device_info_util.dart';

part 'src/util/crypt_util.dart';

part 'src/util/biometric_util.dart';

part 'src/ui/dynamic_craft_wrapper.dart';

part 'src/repository/auth_repository.dart';

part 'src/repository/home_repository.dart';

part 'src/repository/init_repository.dart';

part 'src/session_manager/session_helper.dart';

part 'src/ui/dynamic_static/blurr_load_screen.dart';

part 'src/app_data/model.g.dart';

part 'src/util/alert_dialog_util.dart';

part 'src/ui/dynamic_static/search_module_screen.dart';

part 'src/util/common_lib_util.dart';

part 'src/repository/profile_repository.dart';

part 'src/util/extensions_util.dart';

part 'src/network/local_repository.dart';
