import 'package:big/Providers/DataProvider.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreditCard extends StatefulWidget {
  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  TextEditingController _cardNumberController;
    final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _cardNumberController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          allTranslations.text("Credit Card"),
          style: TextStyle(color: DataProvider().primary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: <Widget>[
            Form(key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: allTranslations.text("Card Number"),
                    ),
                      validator: (String value) {
                      if (value.length != 16 ||
                          !RegExp("^[0-9]{16}").hasMatch(value)) {
                        return allTranslations.text("enter correct card number");
                      }
                      return null;
                    },
                  ),
                  
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: InputDecoration(
                        labelText: allTranslations.text("Expiration Date"),
                        helperText: "MM/YY"),  validator: (String value) {
                      if (value.length!=5||
                          !RegExp("(0[1-9]|10|11|12)/[0-9]{2}").hasMatch(value)) {
                        return allTranslations.text("invalid");
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    decoration:
                        InputDecoration(labelText: allTranslations.text("CVV")),
                    validator: (String value) {
                      if (value.length != 3 ||
                          !RegExp("^[0-9]{3}").hasMatch(value)) {
                        return allTranslations.text("enter correct cvv");
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: InputDecoration(
                        labelText: allTranslations.text("Cardholder Name")),  validator: (String value) {
                      if (
                          !RegExp("(?<! )[-a-zA-Z' ]{2,26}").hasMatch(value)) {
                        return allTranslations.text("enter correct name");
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 32,
            ),
            InkWell(onTap: (){
              _formKey.currentState.validate();
            },
                          child: Container(
                color: DataProvider().primary,
                padding: EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                child: Text(
                  allTranslations.text("Add Credit Card"),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
