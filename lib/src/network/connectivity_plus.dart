import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:craft_dynamic/src/state/plugin_state.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamController<ConnectivityResult> connectionStatusController =
      StreamController<ConnectivityResult>();

  Future<void> initialize() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    connectionStatusController.add(result);

    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      debugPrint("Connection state has changed>>>>>>>>>>>");
      connectionState.value = result;
      connectionStatusController.add(result);
    });
  }

  void dispose() {
    connectionStatusController.close();
  }
}
