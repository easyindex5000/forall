import 'package:big/Providers/DataProvider.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/componets/buildTextForm.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';

import 'customProgess.dart';
import 'submittedPage.dart';

class Payment extends StatefulWidget {
  Payment({Key key}) : super(key: key);

  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  TextEditingController NameController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: Mybar(allTranslations.text("Proceed to Payment"), false),
        body: Column(
          children: <Widget>[
            CustomProgressBar(3),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 32.0, left: 32.0, bottom: 32.0),
                    child: Column(children: <Widget>[
                      SizedBox(height: 15.0),
//              Container(
//                decoration: BoxDecoration(
//                    border: Border.all(color: DataProvider().primary),
//                    borderRadius: BorderRadius.circular(5.0)),
//                width: double.infinity,
//                child: DropdownButtonHideUnderline(
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: DropdownButton<String>(
//                      value: dropdownValue,
//                      icon: Icon(
//                        Icons.arrow_drop_down,
//                        color: DataProvider().primary,
//                      ),
//                      iconSize: 24,
//                      elevation: 16,
//                      style: TextStyle(color: DataProvider().primary),
//                      // underline: Container(
//                      //   height: 2,
//                      //   color: DataProvider().primary,
//                      // ),
//                      onChanged: (String newValue) {
//                        setState(() {
//                          dropdownValue = newValue;
//                        });
//                      },
//                      items: <String>[
//                        'Cash on Delivery',
//                        'Credit or Debit Card',
//                      ].map<DropdownMenuItem<String>>((String value) {
//                        return DropdownMenuItem<String>(
//                          value: value,
//                          child: Text(value),
//                        );
//                      }).toList(),
//                    ),
//                  ),
//                ),
//              ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [BoxShadow(
                                    color: Colors.grey[200],
                                  ),]
                              ),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      buildTextFormField(allTranslations.text("Card Number"),NameController,TextInputType.number),
                                      buildTextFormField(allTranslations.text("Expiration Date"),NameController),
                                      buildTextFormField(allTranslations.text("CVV"),NameController,TextInputType.number,true),
                                      buildTextFormField(allTranslations.text("Cardholder Name"),NameController),
                                      buildTextFormField(allTranslations.text("Cardholder Name"),NameController),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ]),
                  ),
                ],

              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(allTranslations.text( "Total Amount "), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text("4,497.00 USD", style: TextStyle( fontSize: 18.0,color: DataProvider().primary),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width /1.3,
                    height: 45,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new SubmittedPage()));
                      },
                      child: Text(allTranslations.text("Proceed To Payment"), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      color: DataProvider().primary,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
    );
  }
  TextFormField buildTextFormField(String lable,TextEditingController Controller,[TextInputType type,bool secure=false]) {
    return TextFormField(
      decoration: InputDecoration(hintText: lable,),
      controller: Controller,
      keyboardType: type,
      obscureText: secure,
    );
  }
}
