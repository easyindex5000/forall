import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/Uber/UberProvider.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_webservice/places.dart';

class SearchScreen extends StatefulWidget {
  final bool isPickup;

  const SearchScreen({Key key, @required this.isPickup}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Color _greyColor = Color(0xffaba9a9);
  TextEditingController _controller = TextEditingController();

  Future<Placemark> getLocationName() async {
    try {
      var latlong = await MapProvider().getMyLocation();
      return (await MapProvider().getAddressFromLatLong(latlong));
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isPickup ?allTranslations.text( "PICKUP") :allTranslations.text(  "Dropoff"),
          style: TextStyle(color: DataProvider().primary),
        ),
      ),
      body: FutureBuilder<List<PlacesSearchResult>>(
          future: MapProvider().getsuggestion(_controller.text),
          builder: (context, snapshot) {
            return ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 8.6 / 100,
                      vertical: 10),
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shadows: [
                        BoxShadow(
                            color: Color(0xff80c6c6c6),
                            offset: Offset(3, 3),
                            blurRadius: 6)
                      ]),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        color: DataProvider().primary,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          controller: _controller,
                          decoration: InputDecoration(
                              hintText:allTranslations.text( "search"),
                              hintStyle: TextStyle(
                                  color: DataProvider().primary, fontSize: 14),
                              border: InputBorder.none),
                          style: TextStyle(
                              color: DataProvider().primary, fontSize: 14),
                          onChanged: (String value) async {
                            setState(() {});
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.pin_drop, color: DataProvider().primary),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                       allTranslations.text(  "Select on map"),
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                if (widget.isPickup)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (widget.isPickup)
                          Text(
                           allTranslations.text( "Current location"),
                            style: TextStyle(color: _greyColor),
                          ),
                        if (widget.isPickup)
                          FutureBuilder<Placemark>(
                              future: getLocationName(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return ListTile();
                                }
                                if (snapshot.hasError) {
                                  return SizedBox();
                                }

                                return ListTile(
                                  title: Text(snapshot.data.thoroughfare),
                                  subtitle: Text(
                                      snapshot.data.administrativeArea +
                                          ", " +
                                          snapshot.data.subAdministrativeArea),
                                );
                              }),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            allTranslations.text( "Search Locations"),
                          style: TextStyle(color: _greyColor),
                        ),
                        Builder(builder: (context) {
                          if (!snapshot.hasData || snapshot.data.length == 0) {
                            return Center(
                              child: Text(allTranslations.text( "no Data")),
                            );
                          }
                          return ListView.separated(
                            separatorBuilder: (context, value) {
                              return Divider(
                                color: Colors.black,
                              );
                            },
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  Navigator.pop(context,
                                      snapshot.data[index].geometry.location);
                                },
                                title: Text(snapshot.data[index].name),
                                subtitle:
                                    Text(snapshot.data[index].formattedAddress),
                              );
                            },
                          );
                        })
                      ],
                    ),
                  )
              ],
            );
          }),
    );
  }
}
