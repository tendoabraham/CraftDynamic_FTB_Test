import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:craft_dynamic/craft_dynamic.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<List<ConnectivityResult>> connectionStatusController =
      StreamController<List<ConnectivityResult>>.broadcast();

  Future<void> initialize() async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    connectionStatusController.add(results);

    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      AppLogger.appLogD(
        tag: "connection changed",
        message: "connection state has changed to: $results",
      );
      connectionState.value = results.contains(ConnectivityResult.vpn)
          ? ConnectivityResult.vpn
          : results.first;

      // connectionState.value = results.first;
      connectionStatusController.add(results);
    });
  }

  void dispose() {
    connectionStatusController.close();
  }
}

// class ConnectivityService {
//   final Connectivity _connectivity = Connectivity();
//   final StreamController<ConnectivityResult> connectionStatusController =
//       StreamController<ConnectivityResult>.broadcast();

//   // Optional: expose current state with ValueNotifier
//   final ValueNotifier<ConnectivityResult> connectionState =
//       ValueNotifier<ConnectivityResult>(ConnectivityResult.none);

//   Future<void> initialize() async {
//     final ConnectivityResult result =
//         (await _connectivity.checkConnectivity()) as ConnectivityResult;
//     connectionState.value = result;
//     connectionStatusController.add(result);

//     _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
//       AppLogger.appLogD(
//         tag: "connection changed",
//         message: "Connection state has changed to: $result",
//       );
//       connectionState.value = result;
//       connectionStatusController.add(result);
//     } as void Function(List<ConnectivityResult> event)?);
//   }

//   void dispose() {
//     connectionStatusController.close();
//   }
// }

// class ConnectivityService {
//   final Connectivity _connectivity = Connectivity();
//   StreamController<ConnectivityResult> connectionStatusController =
//       StreamController<ConnectivityResult>();

//   Future<void> initialize() async {
//     ConnectivityResult result = await _connectivity.checkConnectivity();
//     connectionStatusController.add(result);

//     _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
//       AppLogger.appLogD(
//           tag: "connection changed", message: "connection state has changed");
//       connectionState.value = result;
//       connectionStatusController.add(result);
//     });
//   }

//   void dispose() {
//     connectionStatusController.close();
//   }
// }

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
