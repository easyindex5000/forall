import 'package:big/Providers/AuthProvider.dart';
import 'package:big/Providers/MainProvider.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/localization/all_translations.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../componets/shopping_icons.dart';
import '../Providers/DataProvider.dart';
import './codeVerify.dart';
import 'package:http/http.dart' as http;
import 'package:big/model/User.dart';
import 'package:provider/provider.dart';

class Verify extends StatefulWidget {
  VerifyMobile createState() => VerifyMobile(newuser: newuser);
  Verify({Key key, @required this.newuser}) : super(key: key);
  User newuser;
}

class VerifyMobile extends State<Verify> {
  final _formKey = GlobalKey<FormState>();

  String phoneCountry = "EG";
  TextEditingController phoneController = new TextEditingController();
  User newuser;
  VerifyMobile({Key key, @required this.newuser});
  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      phoneCountry = countryCode.code.toString();
    });
  }
@override
  void initState() {
    super.initState();
    print(newuser.toJson());
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => User(),
      child: Consumer<User>(builder: (context, user, _) {
        return Scaffold(
          appBar: Mybar("", false),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                       allTranslations.text(     "Mobile Number Verification"),
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Shopping.mobile_search,
                            size: 100.0,
                            color: DataProvider().primary,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                         allTranslations.text(     "Enter your Mobile Number"),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: DataProvider().primary),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        color: DataProvider().primary))),
                            child: new CountryCodePicker(
                              onChanged: _onCountryChange,
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection: 'EG',
                              favorite: ['+2', '+966', 'EG'],
                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,
                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  controller: phoneController,
                                  maxLength: 15,
                                  validator: (value) {
                                    if (value.length < 8) {
                                      return 'Please enter correct number ';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15)
                                  ],
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none,
                                      hintText: '012 - 3567 - 8290'),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    new Container(
                      width: MediaQuery.of(context).size.width * .8,
                      height: MediaQuery.of(context).size.height * .08,
                      child: RaisedButton(
                        child: Text(
                          allTranslations.text( 'SEND CODE'),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                            // newuser.setphoneCountryuser(phoneCountry);
                            // newuser.setphoneuser(phoneController.text);
                            //  await Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           CodeVerifity(userdata: newuser)),
                            // );
                          if (_formKey.currentState.validate()) {
                            newuser.setphoneCountryuser(phoneCountry);
                            newuser.setphoneuser(phoneController.text);
                            var rsponse =
                                await AuthProvider().phoneVerify(newuser);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CodeVerifity(userdata: newuser)),
                            );
                          }
                          
                        },
                        color: DataProvider().primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: DataProvider().primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        );
      },
    ),
  );
}


