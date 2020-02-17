import 'package:big/localization/all_translations.dart';
import 'package:big/main.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectivityChecker {
  OverlayEntry _overlayEntry;

  Connectivity _connectivity;
  bool _isFlaredOpen = false;
  init(context) {
    _connectivity = Connectivity();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult onData) {
      if (onData == ConnectivityResult.none&&!_isFlaredOpen) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry);
        _isFlaredOpen = true;

      } else {
        if (_isFlaredOpen) {
          // navigatorKey.currentState.pop();
          _overlayEntry.remove();
          _isFlaredOpen=false;

        }
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
        builder: (context) => Positioned(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: MaterialApp(
                  home: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            alignment: Alignment.center,
                            child: Container(
                              decoration: ShapeDecoration(
                                  color: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.error, color: Colors.white),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "No Internet Connection",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ));
  }
}
