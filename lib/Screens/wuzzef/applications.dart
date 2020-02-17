import 'package:big/Providers/DataProvider.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';

class Applications extends StatefulWidget {
  @override
  _ApplicationsState createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  List<int> types = [0, 1, 2, 3];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
         allTranslations.text( "Applications"),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: ListView.builder(
            itemCount: types.length,
            padding: EdgeInsets.all(0),
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "UI/UX Designer",
                                  style: TextStyle(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Easy Index",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                          Text(" - Alexandria,Egypt",
                              style: TextStyle(fontSize: 10))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 12,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(allTranslations.text("applied"))
                            ],
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              height: 1,
                              color: index != 0
                                  ? DataProvider().primary
                                  : Colors.black,
                            ),
                          ),
                          Opacity(
                            opacity: types[index] > 0 ? 1 : 0.2,
                            child: Column(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: types[index] > 0
                                      ? Colors.blue
                                      : Colors.grey,
                                  radius: 12,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(allTranslations.text("viewed"))
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                                width: double.infinity,
                                height: 1,
                                color: index > 1
                                    ? DataProvider().primary
                                    : Colors.grey),
                          ),
                          Opacity(
                            opacity: types[index] > 1 ? 1 : 0.2,
                            child: Column(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: types[index] > 1
                                      ? types[index] == 2
                                          ? Colors.green
                                          : Colors.red
                                      : Colors.grey,
                                  radius: 12,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                if (types[index] < 2)
                                  Text(allTranslations.text("shortListed")),
                                if (types[index] == 2)
                                  Text(allTranslations.text("shortListed")),
                                if (types[index] == 3)
                                  Text(allTranslations.text("rejected"))
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
