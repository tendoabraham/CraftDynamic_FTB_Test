import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:craft_dynamic/craft_dynamic.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamController<ConnectivityResult> connectionStatusController =
      StreamController<ConnectivityResult>();

  Future<void> initialize() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    connectionStatusController.add(result);

    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      AppLogger.appLogD(
          tag: "connection changed", message: "connection state has changed");
      connectionState.value = result;
      connectionStatusController.add(result);
    });
  }

  void dispose() {
    connectionStatusController.close();
  }
}

// class ConnectivityService {
//   final Connectivity _connectivity = Connectivity();
//   final StreamController<List<ConnectivityResult>> connectionStatusController =
//       StreamController<List<ConnectivityResult>>.broadcast();

//   late StreamSubscription<List<ConnectivityResult>> _subscription;

//   Future<void> initialize() async {
//     // Check the current connectivity state
//     List<ConnectivityResult> results = await _connectivity.checkConnectivity();
//     connectionStatusController.add(results);

//     // Listen for connectivity changes
//     _subscription = _connectivity.onConnectivityChanged
//         .listen((List<ConnectivityResult> results) {
//       print("Connection state has changed to: $results");
//       connectionStatusController.add(results);
//     });
//   }

//   void dispose() {
//     // Cancel the stream subscription
//     _subscription.cancel();

//     // Close the connectionStatusController
//     connectionStatusController.close();
//   }
// }
