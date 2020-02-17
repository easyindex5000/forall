import 'package:big/Providers/DataProvider.dart';
import 'package:big/componets/MainDrawer.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FORALL",style: TextStyle(color: Colors.black),)),
      drawer: mainDrawer(context, "error"),
      body: Center(
        child: Image.asset(
          "lib/assets/images/error.png",
          width: MediaQuery.of(context).size.width * 3 / 4,
          height: MediaQuery.of(context).size.height * 3 / 4,
        ),
      ),
    );
  }
}
