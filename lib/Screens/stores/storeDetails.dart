import 'package:big/Providers/DataProvider.dart';
import 'package:big/componets/appBar.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class StoreDetails extends StatefulWidget {
  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Mybar("Stors", true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 128,
                  width: 128,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("lib/assets/images/mazad/Wishlist-Empty.png"),),
                ),
                Spacer(),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Seko Salon",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                      Row(
                        children: <Widget>[
                          Icon(Icons.location_on,color: DataProvider().primary,),
                          Text("Mohram Beak, Alexandria")
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.phone,color: DataProvider().primary,),
                          Text("+2 03 123 4567")
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(thickness: 2,),
            buildSlider(),
            Divider(thickness: 2,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Text("Working Time"),
                RichText(
                  text: TextSpan(
                    text: 'Form ',
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(text: 'Tus ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' to'),
                      TextSpan(text: ' Sun ', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Form ',
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(text: '10:00AM ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' to'),
                      TextSpan(text: ' 12:00AM ', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            ),
            Divider(thickness: 2,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Description",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
              Text("Girls Salon"),
            ],
          ),
            Divider(thickness: 2,),
            Row(
              children: <Widget>[
                Container(
                  color: Colors.grey,
                  width: MediaQuery.of(context).size.width /1.13,
                  height: 200,
                  child: Icon(Icons.map,size: 100,),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width /1.13,
                  child: RaisedButton(
                    onPressed: (){neverSatisfied();},
                    child: Text("RESRVEATION",style: TextStyle(color: Colors.white),),
                    color: DataProvider().primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }
  SizedBox buildSlider() {
    return SizedBox(
        height: 170.0,
        width: MediaQuery.of(context).size.width / 1.1,
        child: Carousel(
          images: [
            NetworkImage(
                'https://www.corinthia.com/application/files/6315/0460/7084/corinthia-hotel-tripoli-lobby.jpg'),
            NetworkImage(
                'https://assets.tivolihotels.com/image/upload/q_auto,f_auto/media/minor/tivoli/images/brand_level/footer/1920x1000/thr_aboutus1_1920x1000.jpg'),
            NetworkImage(
                "https://k6u8v6y8.stackpathcdn.com/blog/wp-content/uploads/2014/05/Luxury-Hotels-in-India.jpg")
          ],
          boxFit: BoxFit.contain,
          autoplay: false,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 1000),
          dotSize: 3.0,
          dotIncreasedColor: DataProvider().primary,
          dotBgColor: Colors.transparent,
          dotPosition: DotPosition.bottomCenter,
          dotVerticalPadding: 10.0,
          showIndicator: true,
        ));
  }
  Future<void> neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child:Column(
              children: <Widget>[
               Row(
                 children: <Widget>[
                    Icon(Icons.date_range),
                    Expanded(child: TextFormField(
                    ))
                 ],
               ),
                 Row(
                 children: <Widget>[
                    Icon(Icons.access_time),
                    Expanded(child: TextFormField())
                 ],
               ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Expanded(
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: ButtonTheme(
                         minWidth: double.infinity,
                         child: RaisedButton(
                           onPressed: (){},
                           child: Text("BOOKING",style: TextStyle(color: Colors.white),),
                          color: DataProvider().primary,
                         ),
                       ),
               ),
                   ),
                 ],
               ),
              ],
            ),
          ),
        );
      },
    );
  }
}
