import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/MainProvider.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          allTranslations.text("Contact Us"),
          style: TextStyle(color: DataProvider().secondry),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    width: 180,
                    height: 180,
                    child: Image.asset("lib/assets/images/whatsapp.jpg")),
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side:
                          BorderSide(color: DataProvider().primary, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _controller,
                        validator: (value) {
                          return value == null || value == ""
                              ? allTranslations.text("put valid input")
                              : null;
                        },
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w300,
                          ),
                          border: InputBorder.none,
                          hintText:
                              allTranslations.text("Send your Message …."),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width / 1.2,
                height: 40,
                child: OutlineButton(
                  color: DataProvider().primary,
                  child: Text(
                    allTranslations.text("Send Meesage"),
                    style: TextStyle(color: DataProvider().primary),
                  ),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                  borderSide: BorderSide(color: DataProvider().primary),
                  onPressed: () async {
                    String url =
                        'mailto:info@forallw.com?subject=forall&body=${_controller.text}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(

                  runSpacing: 5,spacing: 20,
                  children: <Widget>[

                    InkWell(
                      child: Container(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                            "lib/assets/images/social/facebook.png"),
                      ),
                      onTap: () async {
                        String url =
                            'https://www.facebook.com/4all2030/';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: 40,
                        height: 40,
                        child:
                            Image.asset("lib/assets/images/social/youtube.png"),
                      ),
                      onTap: () async {
                        String url =
                            'https://www.youtube.com/channel/UCrNjMqkugqO6HtOQYVWDkug?view_as=subscriber';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                            "lib/assets/images/social/instgram.png"),
                      ),
                      onTap: () async {
                        String url =
                            'https://www.instagram.com/4all2030/';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                            "lib/assets/images/social/whatsapp.png"),
                      ),
                      onTap: () async {
                        try{
                          String phone="+201557561432";
                          String url ="whatsapp://send?phone=$phone";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                        catch(e){
                          Toast.show("you can't proceed ", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                        }

                      },
                    ),
                    InkWell(
                      child: Container(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                            "lib/assets/images/social/linkedin.png"),
                      ),
                      onTap: () async {
                        String url =
                            'https://www.linkedin.com/in/for-all-4596b7198/';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                            "lib/assets/images/social/snapchat.png"),
                      ),
                      onTap: () async {
                        String url =
                            'https://www.snapchat.com/add/forall2030';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: 40,
                        height: 40,
                        child:
                            Image.asset("lib/assets/images/social/twitter.png"),
                      ),
                      onTap: () async {
                        String url = 'https://twitter.com/4all2030';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
