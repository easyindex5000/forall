import 'package:big/Providers/DataProvider.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
class EmptyOrder extends StatelessWidget {
  final String title;
  const EmptyOrder({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Container(width: 150,height: 180,
                child: Image.asset("lib/assets/images/shopping_bagorder.png")),
          SizedBox(height: 20,),
            Text(allTranslations.text("There are no orders yet"),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
            SizedBox(height: 80,),
            Spacer(),
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width /1.5,
                child: RaisedButton(
                onPressed: (){Navigator.of(context).pop();},

                child: Text(allTranslations.text("SHOP NOW"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

                color: DataProvider().primary,

              ),
),
          ],
        ),
      ),
    );
  }
}
