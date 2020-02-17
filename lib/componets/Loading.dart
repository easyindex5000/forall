
import 'package:flutter/material.dart';

Future loadWidget(context, Future future)async {
  return await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 100),
      pageBuilder: (_, s, ss) {
        future..then((value) {
          Navigator.pop(context,value);
        })..catchError((error){
                    Navigator.pop(context);
        });
        return Material(
            color: Color(0xff000000).withOpacity(0.5),
            child: WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: FutureBuilder(
                    future: future,
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    })));
      });
}
