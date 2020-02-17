import 'package:big/Providers/DataProvider.dart';

import 'package:big/Providers/wuzzef/wuzzef_provider.dart';
import 'package:big/Screens/wuzzef/signup/professional.dart';
import 'package:big/Screens/wuzzef/signup/uppertab_widget.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Career extends StatefulWidget {
  @override
  _CareerState createState() => _CareerState();
}

class _CareerState extends State<Career> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          allTranslations.text("sign_up"),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ChangeNotifierProvider<WuzzefProvider>(
        create: (_) => WuzzefProvider(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    tab(1),
                    SizedBox(
                      height: 24,
                    ),
                  
                    Text(allTranslations.text("Career Level:")),
                    SizedBox(
                      height: 10,
                    ),
                    _careerLevels(),
                    SizedBox(
                      height: 24,
                    ),
                    Text(allTranslations.text("Type(s) you interested to:")),
                    SizedBox(
                      height: 10,
                    ),
                    _jobTypes(),
                    SizedBox(
                      height: 24,
                    ),
                    DropdownButton(
                      isExpanded: true,
                      hint: Text(allTranslations.text("Job Role")),
                      icon: Icon(Icons.keyboard_arrow_down),
                      value: 1,
                      onChanged: (value) {},
                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child: Text("Developer"),
                        )
                      ],
                    ),
                    DropdownButton(
                      isExpanded: true,
                      hint: Text(allTranslations.text("Job Role")),
                      icon: Icon(Icons.keyboard_arrow_down),
                      value: null,
                      onChanged: (value) {},
                      items: [],
                    ),
                    DropdownButton(
                      isExpanded: true,
                      hint: Text(allTranslations.text("Job Role")),
                      icon: Icon(Icons.keyboard_arrow_down),
                      value: null,
                      onChanged: (value) {},
                      items: [],
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Professional()));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 13),
                        decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            color: DataProvider().primary),
                        child: Text(
                         allTranslations.text( "Next"),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _jobTypes() {
    return Consumer<WuzzefProvider>(builder: (context, model, _) {
      return GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
          childAspectRatio: 5,
        ),
        children: <Widget>[
          _jobTypeItem(model, JobType.fullTime, allTranslations.text("Full-Time")),
          _jobTypeItem(model, JobType.partTime, allTranslations.text("Part-Time")),
          _jobTypeItem(model, JobType.freelance, allTranslations.text("Freelance")),
          _jobTypeItem(model, JobType.internship,allTranslations.text( "Intership")),
          _jobTypeItem(model, JobType.shiftBased, allTranslations.text("Shift Based")),
          _jobTypeItem(model, JobType.volunteer,allTranslations.text( "Volunteer")),
        ],
      );
    });
  }

  Padding _jobTypeItem(WuzzefProvider model, JobType jobtype, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
          onTap: () {
            model.onJobTypeTap(jobtype);
          },
          child: Container(
            alignment: Alignment.center,
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: model.selectedJobTypes.contains(jobtype)
                    ? DataProvider().primary
                    : null),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: TextStyle(
                  color: model.selectedJobTypes.contains(jobtype)
                      ? Colors.white
                      : Colors.black),
            ),
          )),
    );
  }

  Widget _careerLevels() {
    return Consumer<WuzzefProvider>(builder: (context, model, _) {
      return GridView(
        shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
          childAspectRatio: 5,
        ),
        //direction: Axis.horizontal,
        children: <Widget>[
          Row(
            children: <Widget>[
              Checkbox(
                onChanged: (value) {
                  model.onCareerLevelTap(CareerLevel.student);
                },
                value: model.selectedCareerLevels.contains(CareerLevel.student),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Text(allTranslations.text("Student")),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
          Row(
            children: <Widget>[
              Checkbox(
                onChanged: (value) {
                  model.onCareerLevelTap(CareerLevel.entry_level);
                },
                value: model.selectedCareerLevels
                    .contains(CareerLevel.entry_level),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Text(allTranslations.text("Entry Level")),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
          Row(
            children: <Widget>[
              Checkbox(
                onChanged: (value) {
                  model.onCareerLevelTap(CareerLevel.experienced);
                },
                value: model.selectedCareerLevels
                    .contains(CareerLevel.experienced),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Text(allTranslations.text("Experienced")),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
          Row(
            children: <Widget>[
              Checkbox(
                onChanged: (value) {
                  model.onCareerLevelTap(CareerLevel.manger);
                },
                value: model.selectedCareerLevels.contains(CareerLevel.manger),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Text(allTranslations.text("Manager")),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
          Row(
            children: <Widget>[
              Checkbox(
                onChanged: (value) {
                  model.onCareerLevelTap(CareerLevel.ceo);
                },
                value: model.selectedCareerLevels.contains(CareerLevel.ceo),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Text(allTranslations.text("CEO")),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ],
      );
    });
  }
}
