import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:big/Providers/DataProvider.dart';
Widget item(int id, String name, String image, String city, isFavorate,double rating,
    BuildContext context, onTap, onFavorate) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shadows: [
          BoxShadow(
              color: Color(0xff29000000), offset: Offset(3, 3), blurRadius: 6)
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 6,
              child: Center(
                child: FutureBuilder(
                  future: precacheImage(
                      NetworkImage(image),context),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState!=ConnectionState.done){
                      return Container(width: double.infinity,height: 200,color: Colors.grey);
                    }
                    return FadeInImage(
                      placeholder: AssetImage("lib/assets/images/errorImage.png"),
                      image: NetworkImage(image),
                      fit: BoxFit.fitWidth,
                    );
                  }
                ),
              )),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '$name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      InkWell(
                        child: Icon(
                          Icons.favorite,
                          color: isFavorate ? Colors.red : Colors.grey,
                          size: 14,
                        ),
                        onTap: onFavorate,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: DataProvider().primary,
                        size: 16,
                      ),
                      Expanded(
                          child: Text(
                        '$city',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ))
                    ],
                  ),
                  SmoothStarRating(
                    allowHalfRating: true,
                    rating:rating ,
                    size: 12,
                    color: Color(0xffefce4a),
                    borderColor: Colors.grey,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
