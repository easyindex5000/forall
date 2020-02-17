import 'package:big/Providers/DataProvider.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
//import 'expandable.dart';

class Item {
  Item({
    this.expandedValues,
    this.headerValue,
    this.selectedValues,
    this.isExpanded = false,
  });
  Item.fromJson(Map<String, dynamic> json) {
    isExpanded = false;
    selectedValues = [];
    expandedValues = {};
    //sorry for doing this our backend not created with good stracture.
    if (json["name"] != null) {
      headerValue = json["name"];
    } else if (json["value"] != null) {
      headerValue = json["value"];
    }
    json["values"].forEach((item) {
      expandedValues[item["id"]] = item["name"];
    });
  }
  Map<int, String> expandedValues;
  List<int> selectedValues;
  String headerValue;
  bool isExpanded;
}

class RangeItem {
  double min, max;
  bool isExpanded;
  RangeValues rangeValues;
  //TextEditingController startController, endController;
  RangeItem({this.min, this.max, this.isExpanded});
  RangeItem.fromMinAndMax(double min, double max) {
    this.min = min;
    this.max = max;
    rangeValues = RangeValues(min, max);
    this.isExpanded = false;
    // startController = TextEditingController(text: min.toString());
    // endController = TextEditingController(text: max.toString());
  }
}

class Filter extends StatefulWidget {
  List<Item> items = [];
  List<RangeItem> rangeItems = [];

  Filter({
    Key key,
    this.items,
    this.rangeItems,
  }) : super(key: key);
  FilterState createState() => FilterState();
}

class FilterState extends State<Filter> {
  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          try {
            widget.items.forEach((item) {
              item.isExpanded = false;
            });
            widget.items[index].isExpanded = !isExpanded;
          } catch (e) {
            widget.rangeItems[index - widget.items.length].isExpanded =
                !isExpanded;
          }
        });
      },
      children: widget.items.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (
            BuildContext context,
            bool isExpanded,
          ) {
            return Container(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  item.headerValue,
                ),
              ),
            );
          },
          body: Center(
            child: Container(
              color: Colors.white,
              child: Column(
                  children: item.expandedValues.keys.map((key) {
                return LabeledCheckbox(
                  label: item.expandedValues[key],
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  value: item.selectedValues.contains(key),
                  onChanged: (bool newValue) {
                    setState(() {
                      if (item.selectedValues.contains(key)) {
                        item.selectedValues.remove(key);
                      } else {
                        item.selectedValues.add(key);
                      }
                    });
                  },
                );
              }).toList()),
            ),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList()
        ..addAll(
          widget.rangeItems.map((item) {
            return ExpansionPanel(
                isExpanded: widget.rangeItems[0].isExpanded,
                body: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 18,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 48,
                      height: 24,
                      child: Text(item.rangeValues.start.toInt().toString()),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                    ),
                    RangeSlider(
                      min: item.min,
                      values: item.rangeValues,
                      max: item.max,
                      onChanged: (RangeValues values) {
                        item.rangeValues = values;
                        setState(() {});
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 48,
                      height: 24,
                      child: Text(item.rangeValues.end.toInt().toString()),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                    ),
                  ],
                ),
                canTapOnHeader: true,
                headerBuilder: (context, value) {
                  return Container(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        allTranslations.text("Price"),
                      ),
                    ),
                  );
                });
          }),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: ListView(
          children: <Widget>[
            _buildPanel(),
          ],
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () {
                    widget.items.forEach((item) {
                      item.selectedValues = [];
                    });
                    widget.rangeItems.forEach((item) {
                      item.rangeValues = RangeValues(item.min, item.max);
                    });
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: DataProvider().primary),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      allTranslations.text("Reset"),
                      style: TextStyle(color: DataProvider().primary),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, [widget.rangeItems, widget.items]);
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: DataProvider().primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      allTranslations.text("Apply"),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
            Expanded(child: Text(label)),
          ],
        ),
      ),
    );
  }
}
