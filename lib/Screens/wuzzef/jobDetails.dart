import 'package:big/Providers/DataProvider.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JobDetails extends StatefulWidget {
  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  double titleSpace = 5.0, secondSpace = 10.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "UI/UX Designer",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: <Widget>[
                    Container(
                        height: 100,
                        width: 100,
                        child: Image.network(
                          "https://thenextscoop.com/wp-content/uploads/2017/02/apple-logo.jpg",
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "UI/UX Designer-Egypt",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        Text(
                          "Easy index",
                          style: TextStyle(
                              color: DataProvider().primary,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " - sidi Gaber,Alexandria",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 60, vertical: 15),
                            child: Text(
                              allTranslations.text("Apply for Job"),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: DataProvider().primary,
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      allTranslations.text("Job Type"),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: titleSpace,
                    ),
                    Text("Full Time"),
                    Divider(),
                    SizedBox(
                      height: secondSpace,
                    ),
                    Text(
                      allTranslations.text("Career Level"),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: titleSpace,
                    ),
                    Text("Entry Level"),
                    Divider(),
                    SizedBox(
                      height: secondSpace,
                    ),
                    Text(
                      allTranslations.text("Experience Needed"),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: titleSpace,
                    ),
                    Text("0 to 2 years"),
                    Divider(),
                    SizedBox(
                      height: secondSpace,
                    ),
                    Text(
                      allTranslations.text("Salary"),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: titleSpace,
                    ),
                    Text("confidential and Social Insurance"),
                    Divider(),
                    SizedBox(
                      height: secondSpace,
                    ),
                    Text(
                      allTranslations.text("About the Job"),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: titleSpace,
                    ),
                    Wrap(
                      children: <Widget>[
                        Text(
                            "Company Industry Company IndustryCompany IndustryCompany IndustryCompany IndustryCompany IndustryCompany IndustryCompany IndustryCompany IndustryCompany IndustryCompany IndustryCompany Industry"),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: secondSpace,
                    ),
                    Text(
                      allTranslations.text("Company Industry"),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: titleSpace,
                    ),
                    Wrap(
                      children: <Widget>[
                        Text(
                            "Company IndustryCompany IndustryCompany IndustryCompany Industry"),
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
