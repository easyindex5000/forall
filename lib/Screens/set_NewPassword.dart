import 'package:big/Screens/OnlineStoreHomeScreen.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/DataProvider.dart';
import 'package:big/Screens/ForAllHome.dart';

class SetNewPassword extends StatefulWidget {
  _SetNewPassword createState() => _SetNewPassword();
}

class _SetNewPassword extends State<SetNewPassword> {
  Color danger = DataProvider().secondry;
  Color danger2 =DataProvider().secondry;
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmpasswordController = new TextEditingController();

    String changePassword = allTranslations.text('changePassword');
    String currentPassword = allTranslations.text('currentPassword');
    String newPassword = allTranslations.text('newPassword');
    String confirmPassword = allTranslations.text('confirmPassword');
    String updatePassword = allTranslations.text('updatePassword');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Mybar('$changePassword', false),
        body: SafeArea(
          minimum: EdgeInsets.all(DataProvider().paddingApp),
          child: SingleChildScrollView(
            child: Container(
              child: Center(
                  child: Form(
                    key:_formKey,
                       child: Column(
                      children: <Widget>[
                        Consumer<DataProvider>(
                          builder: (context, dataProvider, _) => TextFormField(
                            obscureText: dataProvider.securePassword,
                            controller: passwordController,
                            maxLength: 32,
                            decoration: InputDecoration(
                              // border: OutlineInputBorder(),
                              labelText: '$newPassword',
                              counterText: "",
                              // icon: new Icon(Icons.lock_outline),
                              suffixIcon: new IconButton(
                                icon: new Icon(
                                  Icons.remove_red_eye,
                                  color: danger,
                                ),
                                onPressed: () {
                                  if (danger == DataProvider().secondry) {
                                    setState(() {danger = Colors.red;});
                                  } else if (danger == Colors.red) {
                                    setState(() {danger = DataProvider().secondry;});
                                  }
                                  bool viewHide =
                                  dataProvider.securePassword == true ? false : true;
                                  dataProvider.securePassword = viewHide;
                                },
                              ),
                            ),
                              validator: (val){
                              if(val.isEmpty){
                                return "this field is required";
                              }
                              else{
                                return null;
                              }
                              },
                            onSaved: (value) {},
                          ),
                        ),
                        Consumer<DataProvider>(
                          builder: (context, dataProvider, _) => TextFormField(
                            obscureText: dataProvider.securePassword2,
                            controller:confirmpasswordController ,
                            maxLength: 32,
                            validator: (val){
                              if(val.isEmpty){
                                return "this field is required";
                              }
                              else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              // border: OutlineInputBorder(),
                              labelText: '$confirmPassword',
                              counterText: "",
                              // icon: new Icon(Icons.lock_outline),
                              suffixIcon: new IconButton(
                                icon: new Icon(Icons.remove_red_eye, color: danger2,),
                                onPressed: () {
                                  if (danger2 == DataProvider().secondry) {
                                    setState(() {
                                      danger2 = Colors.red;
                                    });
                                  } else if (danger2 == Colors.red) {
                                    setState(() {danger2 = DataProvider().secondry;});
                                  }
                                  bool viewHide =
                                  dataProvider.securePassword2 == true ? false : true;
                                  dataProvider.securePassword2 = viewHide;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        ButtonTheme(
                          height: 40,
                          minWidth: MediaQuery.of(context).size.width /1.5,
                          child: RaisedButton(
                            onPressed: (){
                              if(_formKey.currentState.validate()){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => OnlineShoppingHome()));
                              }
                             },
                            color: DataProvider().primary,
                            child: Text("$updatePassword",style: TextStyle(color: Colors.white,fontSize: 16),),
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
            ),
          ),
        ),
    );
  }
}
