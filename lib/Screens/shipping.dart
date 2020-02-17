import 'package:big/Providers/DataProvider.dart';
import 'package:big/Screens/customProgess.dart';
import 'package:big/Screens/payment.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/componets/buildTextForm.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';

class Shipping extends StatefulWidget {
  Shipping({Key key}) : super(key: key);

  _ShippingState createState() => _ShippingState();
}

class _ShippingState extends State<Shipping> {
  Country _selected;
  //Country selectedCountry = ;
  TextEditingController NameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController address2Controller = new TextEditingController();
  TextEditingController CodeController = new TextEditingController();
  double hieghtAll = 20.0;
  String demoaddress = "xzy street, abc city";
  String demozip = "123456";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: Mybar(allTranslations.text("Shipping"), false),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right:32.0,left:32.0,bottom:32.0),
                    child: Column(children: <Widget>[
                      CustomProgressBar(2),
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
                                buildTextFormField(allTranslations.text("name"),NameController),
                                buildTextFormField(allTranslations.text("Email"),emailController),
                                buildTextFormField(allTranslations.text("Phone"),phoneController),
                                buildTextFormField(allTranslations.text("Address") +1.toString(),addressController),
                                buildTextFormField(allTranslations.text("Address")+2.toString(),address2Controller),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
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
                                Text(allTranslations.text("Discount Voucher"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17.0),),

                                Row(
                                  children: <Widget>[
                                    Expanded(child: buildTextFormField("Voucher Code",CodeController)),
                                    Expanded(child: FlatButton(child: Text(allTranslations.text("Redeem"),style: TextStyle(color: DataProvider().primary),),
                                      onPressed: (){},
                                    )),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(allTranslations.text("name"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                      Text(allTranslations.text("Quantiy"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                      Text(allTranslations.text("Price"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("name",style: TextStyle(color: Colors.black,),),
                                      Text("5",style: TextStyle(color: Colors.black,),),
                                      Text("200",style: TextStyle(color: Colors.black,),),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(allTranslations.text("Subtotal"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                      Text("USD 500",style: TextStyle(color: Colors.black,),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(allTranslations.text("Discount"),style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                      Text("-USD 50",style: TextStyle(color: Colors.red,),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(allTranslations.text("Shipping"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                      Text("USD 50",style: TextStyle(color: Colors.black,),),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(allTranslations.text("Total Amount"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                      Text("USD 500",style: TextStyle(color: Colors.black,),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ),
                      )

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
                    Text(allTranslations.text("Total Amount "), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
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
                        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new Payment()));

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

  TextFormField buildTextFormField(String lable,TextEditingController Controller) {
    return TextFormField(
                      decoration: InputDecoration(hintText: lable,),
                      controller: Controller,
                    );
  }
}
