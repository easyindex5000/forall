import 'package:big/componets/Error.dart';
import 'package:big/componets/shopping_icons.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:big/Providers/DataProvider.dart';
import '../componets/appBar.dart';
import '../componets/horizontal_listview.dart';
import '../componets/products.dart';
import '../componets/filter.dart';
import 'package:async/async.dart';
import 'dart:convert';

class SubSubCategory extends StatefulWidget {
  String subtitle;
  int catID;
  String sorttype;
  String ordertype;
  List attribudes;
  List brandIDs;
  int minprice, maxprice;
  SubSubCategory(
      {Key key,
      this.sorttype = "",
      this.ordertype = "",
      @required this.subtitle,
      this.catID,
      this.attribudes=const [],
      this.brandIDs=const [],
      this.minprice=0,
      this.maxprice=100})
      : super(key: key);
  @override
  _SubSubCategoryState createState() => _SubSubCategoryState();
}

class _SubSubCategoryState extends State<SubSubCategory> {
//////////////////// header of fuckn list //////////////
  Widget header(modalTitle) => Ink(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                modalTitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: DataProvider().primary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
//////////////////////////////////////////////////////////

  Widget sortwidget() => Column(
        children: <Widget>[
          _createTile(context, allTranslations.text('A To Z'), () {
            widget.sorttype = "name";
            widget.ordertype = "asc";
            widget.minprice = null;
            widget.maxprice = null;
            widget.brandIDs = null;
            widget.attribudes = null;
            setState(() {});
          }),
          _createTile(context, allTranslations.text('Low price'), () {
            widget.sorttype = "price";
            widget.ordertype = "asc";
            widget.minprice = null;
            widget.maxprice = null;
            widget.brandIDs = null;
            widget.attribudes = null;
            setState(() {});
          }),
          _createTile(context, allTranslations.text('Top Price'), () {
            widget.sorttype = "price";
            widget.ordertype = "desc";
            widget.minprice = null;
            widget.maxprice = null;
            widget.brandIDs = null;
            widget.attribudes = null;
            setState(() {});
          }),
          _createTile(context, allTranslations.text('Top Rating'), () {
            widget.sorttype = "rate";
            widget.ordertype = "desc";
            widget.minprice = null;
            widget.maxprice = null;
            widget.brandIDs = null;
            widget.attribudes = null;
            setState(() {});
          }),
        ],
      );

  ListTile _createTile(BuildContext context, String name, Function action) {
    return ListTile(
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

/////////////////////////// fucken footer for filter

  Widget footer() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlineButton(
                child: Text(allTranslations.text('Reset')),
                color: DataProvider().primary,
                borderSide: BorderSide(color: DataProvider().primary),
                onPressed: () {},
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: RaisedButton(
              color: DataProvider().primary,
              onPressed: () {},
              child: Text(allTranslations.text('Apply'),
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );

  /////////////////
  void _mainBottomSheet(BuildContext context, String name, Widget widget,
      [Widget footer]) async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Color(0XFF737373),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.only(
                        topLeft: new Radius.circular(15.0),
                        topRight: new Radius.circular(15.0))),
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 3.0, left: 3.0, bottom: 1.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //mainAxisSize: MainAxisSize.max,
                    //  mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      header(name),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                          top: BorderSide(
                              width: 1.0,
                              color: Color(0xFF5d5e62).withOpacity(0.3)),
                          bottom: BorderSide(
                              width: 1.0,
                              color: Color(0xFF5d5e62).withOpacity(0.3)),
                        )),
                        child: ListView(
                          children: <Widget>[
                            widget,
                          ],
                        ),
                      )),
                      if (footer != null) footer
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

//////////////////// row of options like sort and filter
  //MyStatefulWidget expand = new MyStatefulWidget();
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: Mybar(widget.subtitle, true),
      body: new Column(
        children: <Widget>[
          //padding widget
          Container(
            color: Color(0XFFf4f4f4),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(children: <Widget>[
                    //  Text('${DataProvider.productList.length} Items'),
                  ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(allTranslations.text('Sort By')),
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                            width: 1.0,
                                            color: Color(0xFFE5E3E3)),
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Shopping.swap_vertical),
                                      onPressed: () async {
                                        await _mainBottomSheet(
                                            context,
                                            allTranslations.text('Sort By'),
                                            sortwidget());
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(allTranslations.text('Filter')),
                                IconButton(
                                    icon: Icon(
                                      Shopping.path_263,
                                      size: 20.0,
                                    ),
                                    onPressed: () async {
                                                                              List attribudes =[];

                                      var result = await _bottomSheetFilter(
                                          widget.catID);
                                    
                                      if (result != null) {
                                          result[1].forEach((item) {
                                        if (item.headerValue !=
                                            "brands") {
                                        widget.  attribudes.addAll( item.selectedValues);
                                        } else if (item.headerValue ==
                                            "brands") {
                                          widget.brandIDs = item.selectedValues;
                                        }
                                      });

                                        widget.sorttype = "";
                                        widget.ordertype = "";
                                        setState(() {});
                                      }
                                    }),
                              ],
                            )
                          ],
                        ),
                      ]),
                ],
              ),
            ),
          ),
          //grid view
          Builder(
              key: UniqueKey(),
              builder: (context) {
       
                return Flexible(
                    child: ProductsWidget(
                  catId: widget.catID,
                  sorttype: widget.sorttype,
                  ordertype: widget.ordertype,
                  attribudes: widget.attribudes ?? [],
                  brandIDs: widget.brandIDs ?? [],
                  maxPrice: widget.maxprice,
                  minPrice: widget.minprice,
                ));
              }),
        ],
      ),
    );
  }

  _bottomSheetFilter(int catID) {
    AsyncMemoizer _memorizerFilter = AsyncMemoizer();

    List<Item> items = [];
    double minPrice, maxPrice;

    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: double.infinity,
            color: Color(0XFF737373),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.only(
                        topLeft: new Radius.circular(15.0),
                        topRight: new Radius.circular(15.0))),
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 3.0, left: 3.0, bottom: 1.0),
                  child: Column(
                    children: <Widget>[
                      header("Filter"),
                      Expanded(
                        child: FutureBuilder(
                            future: _memorizerFilter.runOnce(() async {
                          await DataProvider().filterValues(catID).then((res) {
                            var data = json.decode(res)["data"]["checkbox"];

                            items = [];
                            data.forEach((item) {
                              items.add(Item.fromJson(item));
                            });

                            minPrice = json
                                .decode(res)["data"]["min_price"]
                                .toDouble();
                            maxPrice = json
                                .decode(res)["data"]["max_price"]
                                .toDouble();
                          });
                        }), builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return CustomErrorWidget();
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Filter(
                              items: items,
                              rangeItems: [
                                RangeItem.fromMinAndMax(minPrice, maxPrice)
                              ],
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
