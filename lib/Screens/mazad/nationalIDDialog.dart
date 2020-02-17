import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/Mazad/mazadProvider.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';

nationalIdDialog(
  BuildContext context,
) async {
  final _formKey = GlobalKey<FormState>();

  TextEditingController controller = TextEditingController();
  return await showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.only(top: 16.0),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 3 / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Text(
                      allTranslations.text("National ID"),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: DataProvider().primary),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Container(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.width * 13.5 / 100),
                    decoration: BoxDecoration(
                        border: Border.all(color: DataProvider().primary)),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (value) {
                          return value.length > 20
                              ? allTranslations
                                  .text("less than or equal 20 number")
                              : null;
                        },
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "00000000",
                          border: InputBorder.none,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.width * 13.5 / 100,
                        vertical: 10),
                    child: Text(
                      allTranslations.text("Enter 14 number of your ID"),
                      style: TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            decoration: BoxDecoration(
                              color: DataProvider().primary,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0)),
                            ),
                            child: Text(
                              allTranslations.text("Save"),
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              await MazadProvider().createUser(controller.text);
                              Navigator.pop(context, false);
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0)),
                            ),
                            child: Text(
                              allTranslations.text("Close"),
                              style: TextStyle(color: DataProvider().primary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
