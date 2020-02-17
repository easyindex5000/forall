import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/MainProvider.dart';
import 'package:big/componets/Loading.dart';
import 'package:big/localization/all_translations.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';

class ChangeMobileNumber extends StatefulWidget {
  @override
  _ChangeMobileNumberState createState() => _ChangeMobileNumberState();
}

class _ChangeMobileNumberState extends State<ChangeMobileNumber> {
  AsyncMemoizer _memorizer = AsyncMemoizer();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();
  String _countryCode;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _phoneController.text = prefs.getString("phone");
    _countryCode = prefs.getString('country_code');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text("Mobile Number"),
            style: TextStyle(color: DataProvider().secondry)),
      ),
      body: FutureBuilder(future: _memorizer.runOnce(() async {
        return await getData();
      }), builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 64,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Spacer(),
                          CountryCodePicker(
                            padding: EdgeInsets.all(0),
                            textStyle: TextStyle(fontSize: 14),
                            initialSelection: _countryCode,
                            favorite: ['+966','SA','+20', 'EG'],
                            showCountryOnly: false,
                            alignLeft: false,
                            onChanged: (CountryCode code) {
                              _countryCode = code.code;
                            },
                          ),
                          Spacer(),
                          Divider(
                            color: DataProvider().primary,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _phoneController,keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.length < 8) {
                                return 'Please enter correct number ';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: DataProvider().primary),
                          ),
                        ),
                        Divider(color: DataProvider().primary)
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              ButtonTheme(
                minWidth: double.infinity,
                height: 50.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: DataProvider().primary,
                  ),
                  child: RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                      await loadWidget(context,    changeNumber());
                        }
                      },
                      child: Text(
                       allTranslations.text( "Change Mobile Number"),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      color: Colors.transparent),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  changeNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Map<String, String> body = {
      'phone': _phoneController.text,
      'country_code': _countryCode
    };
    var response = await http.post(
        MainProvider().baseUrl + "/auth/customer/change_number",
        body: json.encode(body),
        headers: headers);
    var res = json.decode(response.body);
    if (res["success"]) {
      Toast.show(allTranslations.text("Done"), context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("phone", _phoneController.text);
      prefs.setString('country_code', _countryCode);
      Navigator.pop(context);
    } else {
      Toast.show(allTranslations.text("error"), context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
