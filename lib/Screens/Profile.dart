import 'dart:convert';
import 'dart:io';
import 'package:big/Providers/AuthProvider.dart';
import 'package:big/Providers/ColorsProvider.dart';
import 'package:big/Providers/DataProvider.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/componets/buildTextForm.dart';
import 'package:big/componets/shopping_icons.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'Settings/changePassword.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:big/componets/Loading.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();

  String username = "mohamed";
  String userEmail = "mohamed.essam9393@gmail.com";
  String userImage =
      "https://cdn0.iconfinder.com/data/icons/avatar-78/128/12-512.png";
  String phone;
  String phoneCountry;
  bool addImage = false;
  String userToken;
  String base64Image;
  String editAccount = allTranslations.text('editAccount');
  String editPassword = allTranslations.text('editPassword');
  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 1);
    image = await FlutterExifRotation.rotateAndSaveImage(path: image.path);
    await loadWidget(context, editAccout(username, userEmail, image));
    setState(() {});
  }

  Future getImage2() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = await FlutterExifRotation.rotateAndSaveImage(path: image.path);

    await editAccout(username, userEmail, image);
    setState(() {});
  }

  double hieghtAll = 20.0;
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$editAccount"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Shopping.edit,
              color: DataProvider().primary,
            ),
            onPressed: () async{
             await buildShowDialog(context, username, userEmail);
             setState(() {
               
             });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: ListView(
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Builder(builder: (
                          context,
                        ) {
                          bool hasError = false;
                          return FutureBuilder(
                              future: precacheImage(
                                  NetworkImage(userImage), context,
                                  onError: (_, __) {
                                    print(userImage);
                                hasError = true;
                              }),
                              builder: (context, snapshot) {
                                
                                  if (snapshot.connectionState != ConnectionState.done) {
                                    print(userImage);
                                    return CircleAvatar(
                                      radius: 65,
                                      backgroundColor: Colors.grey,
                                    );
                                  }
                                 
                                  if (!hasError &&
                                      snapshot.connectionState ==
                                          ConnectionState.done) {
                                    return CircleAvatar(
                                      radius: 65,
                                      backgroundImage: NetworkImage(userImage),
                                    );
                                  } else {
                                    return CircleAvatar(
                                      radius: 65,
                                      backgroundImage: AssetImage(
                                          "lib/assets/images/errorImage.png"),
                                    );
                                  }
                             
                              });
                        }),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (addImage == false) {
                                    addImage = true;
                                  } else if (addImage == true) {
                                    addImage = false;
                                  }
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
                addImage
                    ? new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            onPressed: getImage,
                            icon: Icon(Icons.linked_camera),
                            iconSize: 30.0,
                            color: ColorProvider().primary,
                          ),
                          IconButton(
                            onPressed: getImage2,
                            icon: Icon(Icons.add_photo_alternate),
                            iconSize: 30.0,
                            color: ColorProvider().primary,
                          ),
                        ],
                      )
                    : SizedBox(height: hieghtAll),
                SizedBox(height: hieghtAll),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      allTranslations.text("name"),
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      username,
                      style: TextStyle(
                          color: DataProvider().primary, fontSize: 16),
                    ),
                    Divider(
                      color: DataProvider().primary,
                    )
                  ],
                ),
                SizedBox(height: hieghtAll),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      allTranslations.text("E-mail"),
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      userEmail,
                      style: TextStyle(
                          color: DataProvider().primary, fontSize: 16),
                    ),
                    Divider(
                      color: DataProvider().primary,
                    )
                  ],
                ),
                SizedBox(height: hieghtAll),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          CountryCodePicker(
                            padding: EdgeInsets.all(0),
                            textStyle: TextStyle(fontSize: 14),
                            initialSelection: phoneCountry,
                            favorite: ['+966','SA','+20', 'EG'],
                            showCountryOnly: false,
                            alignLeft: false,
                          ),
                          Divider(
                            color: DataProvider().primary,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              phone,
                              style: TextStyle(color: DataProvider().primary),
                            ),
                            SizedBox(height: 20,),
                            Divider(color: DataProvider().primary,height: 0,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: hieghtAll),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[
                //     Text(
                //       allTranslations.text("country"),
                //       style: TextStyle(color: Colors.grey, fontSize: 12),
                //     ),
                //     Text(
                //       username,
                //       style: TextStyle(
                //           color: DataProvider().primary, fontSize: 16),
                //     ),
                //     Divider(
                //       color: DataProvider().primary,
                //     )
                //   ],
                // ),
                // SizedBox(height: hieghtAll),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[
                //     Text(
                //       allTranslations.text("city"),
                //       style: TextStyle(color: Colors.grey, fontSize: 12),
                //     ),
                //     Text(
                //       username,
                //       style: TextStyle(
                //           color: DataProvider().primary, fontSize: 16),
                //     ),
                //     Divider(
                //       color: DataProvider().primary,
                //     )
                //   ],
                // ),
            
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future buildShowDialog(BuildContext context, String name, String email) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController = TextEditingController(text: email);
    return showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: Container(
              height: 220,
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: Colors.white),
              width: MediaQuery.of(context).size.width - 64,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: nameController,
                          style: TextStyle(color: DataProvider().primary),
                          validator: (value) {
                            if (value.length < 5) {
                              return allTranslations
                                  .text('Please enter correct name');
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: allTranslations.text("name"),
                          ),
                        ),
                        TextFormField(
                            controller: emailController,
                            style: TextStyle(color: DataProvider().primary),
                            decoration: InputDecoration(
                                labelText: allTranslations.text("Email")),
                            validator: (value) {
                              if (value.length < 8) {
                                return 'Please enter Password more than 7 ';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 24,
                        ),
                        InkWell(
                          onTap: () async {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            try {
                              await editAccout(
                                  nameController.text, emailController.text);
                              Navigator.pop(context);
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              allTranslations.text("save"),
                              style: TextStyle(color: Colors.white),
                            ),
                            width: double.infinity,
                            color: DataProvider().primary,
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('userName');
      userEmail = prefs.getString('userEmail');
      userImage = prefs.getString('userImage');
      phone = prefs.getString('phone');
      phoneCountry = prefs.getString('country_code');
    });
  }

  Future editAccout(String name, String email, [File image]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    File f = image;
    if (image != null) {
      if (image.lengthSync() > 1000000) {
        f = await _compressFile(image);
      }
    }

    await AuthProvider().editAccount(name, email, f).then((res) {
      var data = json.decode(res);
      username = data['name'];
      userEmail = data['email'];

      if (data['avatar'] != null) {
        userImage = data["avatar"];
              prefs.setString('userImage', userImage);

      }
      prefs.setString('userName', username);
      prefs.setString('userEmail', userEmail);
      if (data['avatar'] != null) {
        userImage = data['avatar'];
              prefs.setString('userImage', userImage);

      }
    });
  }

  Future<File> _compressFile(File file) async {
    
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      file.absolute.path,
      quality: 80,
    );
    if (result.lengthSync() > 1000000) {
      return _compressFile(result);
    }
    return result;
  }
}
