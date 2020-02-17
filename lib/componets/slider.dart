import 'package:big/Providers/ColorsProvider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:big/model/Productsmodel.dart';

_convertData(List<Images> sliderImages, context) async {
  List<ImageProvider> images = [];
  for (Images image in sliderImages) {
    bool hasError = false;
    await precacheImage(NetworkImage(image.src), context, onError: (_, __) {
      hasError = true;
    });

    if (hasError) {
      images.add(AssetImage("lib/assets/images/errorImage.png"));
    } else {
      images.add(NetworkImage(image.src));
    }
  }
  return images;
}

SizedBox silder(BuildContext context, List<Images> sliderImages) {
  return SizedBox(
    width: double.infinity,
    child: Center(
      child: FutureBuilder(
          future: _convertData(sliderImages, context),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                color: Colors.grey,
              );
            }
            if (!snapshot.hasData) {
              return Container(
                color: Colors.grey,
              );
            }
            return Carousel(
              boxFit: BoxFit.contain,
              autoplay: false,
              animationCurve: Curves.fastOutSlowIn,
              animationDuration: Duration(milliseconds: 1000),
              dotSize: 5.0,
              dotIncreasedColor: ColorProvider().danger,
              dotBgColor: Colors.transparent,
              dotPosition: DotPosition.bottomCenter,
              dotVerticalPadding: 10.0,
              showIndicator: true,
              // indicatorBgPadding: 7.0,
              images: snapshot.data.toList(),
            );
          }),
    ),
  );
}
