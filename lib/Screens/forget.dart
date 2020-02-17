import 'package:big/Providers/DataProvider.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import './confirm.dart';

class ForgetPassword extends StatelessWidget {
  String email;
  final _formKey = GlobalKey<FormState>();

  TextEditingController EmailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Mybar(allTranslations.text('Forget Password'), false),
      body: SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: Center(
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              SizedBox(height: 30),
              Text(
                allTranslations
                    .text('Enter your E-mail to reset your password'),
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    //     labelText: "Email",
                    hintText: allTranslations.text("Email"),
                  ),
                  validator: (input) =>
                      !input.contains('@') ? 'Not a Valid E-mail' : null,
                  onSaved: (input) => email = input,
                  keyboardType: TextInputType.emailAddress,
                  controller: EmailController,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              //    new SignUPButton(nameController: nameController,title: 'Submit',navigate:path),
              ButtonTheme(
                height: 50,
                child: RaisedButton(
                  onPressed: () {
                    //  if (_formKey.currentState.validate()) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConfirmPassword()));
                    //    }
                  },
                  child: Text(
                    allTranslations.text(        "SUBMIT"),
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  color: DataProvider().primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
