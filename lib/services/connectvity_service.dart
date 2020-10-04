import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:overlay_support/overlay_support.dart';

enum ConnectivityStatus { WiFi, Cellular, Offline }

class ConnectivityService {
  static ConnectivityStatus connectivityStatus;
  BuildContext context;
  // Create our public controller
  Stream<ConnectivityStatus> get valueStream =>
      connectionStatusController.stream;
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();
  // getCurrentStatus() async {
  //   print('hi from connection stream');
  //   ConnectivityResult connectivityResult =
  //       await Connectivity().checkConnectivity();
  //   connectionStatusController.add(_getStatusFromResult(connectivityResult));
  // }

  ConnectivityService() {
    // Subscribe to the connectivity Chanaged Steam
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print('*****************************');
      print(_getStatusFromResult(result));
      // Use Connectivity() here to gather more info if you need t
      connectionStatusController.add(_getStatusFromResult(result));
      if (_getStatusFromResult(result) == ConnectivityStatus.Offline) {
        connectivityStatus = ConnectivityStatus.Offline;
        print(connectivityStatus);
        showOverlayNotification((context) {
          this.context = context;
          return Card(
            color: Colors.red[800],
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: SafeArea(
                child: Container(
              width: double.infinity,
              child: ListTile(
                leading: Icon(
                  Icons.signal_wifi_off,
                  color: Colors.white,
                ),
                title: Text(
                  translator.translate('connectiom_errir'),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )),
          );
        }, duration: Duration(hours: 4000));
      } else if (_getStatusFromResult(result) != ConnectivityStatus.Offline &&
          this.context != null) {
        connectivityStatus = ConnectivityStatus.Cellular;
        print(connectivityStatus);
        OverlaySupportEntry.of(context).dismiss();
      }
    });
  }
  // Convert from the third part enum to our own enum
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}
