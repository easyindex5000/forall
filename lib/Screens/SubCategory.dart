import 'dart:convert';

import 'package:big/Providers/Mazad/mazadProvider.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/shopping_icons.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:big/Providers/DataProvider.dart';
import 'package:provider/provider.dart';
import '../componets/appBar.dart';
//my own imports
import '../componets/horizontal_listview.dart';
import '../componets/products.dart';
import '../componets/filter.dart';
import 'package:big/model/Productsmodel.dart';
import 'package:big/Screens/SubSubCategory.dart';
import 'package:async/async.dart';

class SubCategory extends StatefulWidget {
  final String subtitle;
  final int catID;
  final List<Data> listOfProducts = [];

  SubCategory({Key key, @required this.subtitle, this.catID}) : super(key: key);
  @override
  _SubCategoryState createState() => _SubCategoryState(catId: catID);
}

class _SubCategoryState extends State<SubCategory> {
  int catId;
  String modalTitle;
  final String sort = allTranslations.text('sort_by');
  final String filtertext = allTranslations.text('filter');
  final String sorttopPrice = allTranslations.text('sorttopPrice');
  final String sortPrice = allTranslations.text('sortPrice');
  final String sortRate = allTranslations.text('sortRate');
  final String sortName = allTranslations.text('sortName');
  final String atoz = allTranslations.text('atoz');
  final String lowprice = allTranslations.text('lowprice');
  final String topprice = allTranslations.text('topprice');
  final String toprating = allTranslations.text('toprating');
  final String reset = allTranslations.text('reset');
  final String apply = allTranslations.text('apply');
  final String items = allTranslations.text('items');

  //Sort sort = new Sort();

  _SubCategoryState({this.catId});

  @override
  void initState() {
    super.initState();
  }

//////////////////// header of fuckn list //////////////
  Widget header(modalTitle) => Ink(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                modalTitle,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: DataProvider().primary),
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

/////////////////////////// fucken footer for filter

  Widget footer() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlineButton(
                child: Text('$reset'),
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
              child: Text('$apply', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );

  /////////////////
  void _mainBottomSheet(BuildContext context, String name, Widget widget,
      [Widget footer]) {
    showModalBottomSheet(
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

/////////////////////////////////////////////////////

  Widget sortwidget() => Column(
        children: <Widget>[
          _createTile(
              context,
              '$atoz',
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SubSubCategory(
                            catID: catId,
                            subtitle: "$sortName",
                            sorttype: "name",
                            ordertype: "asc",
                            attribudes: [],
                          )))),
          _createTile(
              context,
              '$lowprice',
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SubSubCategory(
                            catID: catId,
                            subtitle: "$sortPrice",
                            attribudes: [],
                            sorttype: "price",
                            ordertype: "asc",
                          )))),
          _createTile(
              context,
              '$topprice',
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SubSubCategory(
                            catID: catId,
                            subtitle: "$sorttopPrice",
                            sorttype: "price",
                            ordertype: "desc",
                            attribudes: [],
                          )))),
          _createTile(
              context,
              '$toprating',
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SubSubCategory(
                            catID: catId,
                            subtitle: "$sortRate",
                            sorttype: "rate",
                            ordertype: "desc",
                            attribudes: [],
                          )))),
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

//////////////////// row of options like sort and filter
  //MyStatefulWidget expand = new MyStatefulWidget();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Mybar(widget.subtitle, true),
      body: new Column(
        children: <Widget>[
          HorizontalList(catId),
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
//                    Text('${DataProvider.productList.length} $items'),
                  ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () => _mainBottomSheet(
                                  context, '$sort', sortwidget()),
                              child: Row(
                                children: <Widget>[
                                  Text(sort),
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
                                        onPressed: () {},
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                var result = await _bottomSheetFilter(catId);

                                List attribudes = [];
                                List brandIDs;
                                result[1].forEach((item) {
                                  if (item.headerValue == "Size") {
                                    attribudes.addAll(item.selectedValues);
                                  } else if (item.headerValue != "brands") {
                                    attribudes.addAll(item.selectedValues);
                                  } else if (item.headerValue == "brands") {
                                    brandIDs = item.selectedValues;
                                  }
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SubSubCategory(
                                              ordertype: "",
                                              sorttype: "",
                                              catID: catId,
                                              subtitle: "Filter",
                                              attribudes: attribudes,
                                              brandIDs: brandIDs,
                                              minprice: result[0][0]
                                                  .rangeValues
                                                  .start
                                                  .toInt(),
                                              maxprice: result[0][0]
                                                  .rangeValues
                                                  .end
                                                  .toInt(),
                                            )));
                              },
                              child: Row(
                                children: <Widget>[
                                  Text(filtertext),
                                  IconButton(
                                    icon: Icon(
                                      Shopping.path_263,
                                      size: 20.0,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ]),
                ],
              ),
            ),
          ),
          //grid view
          Flexible(
              child: ProductsWidget(
            catId: catId,
          )),
        ],
      ),
    );
  }

  setLength() {}
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
                      header(allTranslations.text("Filter")),
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
