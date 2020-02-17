import 'dart:convert';
import 'dart:io';
import 'package:big/Providers/ColorsProvider.dart';
import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/Mazad/mazadProvider.dart';
import 'package:big/Screens/mazad/MazadHome.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/ErrorScreen.dart';
import 'package:big/componets/Loading.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/model/mazad/auctionProduct.dart';
import 'package:big/model/mazad/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:big/componets/buildTextForm.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';
import 'nationalIDDialog.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:async/async.dart';

class AddAcution extends StatefulWidget {
  AuctionProduct product;
  AddAcution({this.product});
  @override
  _AddAcutionState createState() => _AddAcutionState();
}

class _AddAcutionState extends State<AddAcution> {
  bool imageHasError = false;

  List<Category> categories = [];
  Category selectedCategory;
  int selectedSubCategory;

  TextEditingController nameController = new TextEditingController();
  TextEditingController DescriptionController = new TextEditingController();
  TextEditingController StartPriceController = new TextEditingController();
  TextEditingController IncrementController = new TextEditingController();
  TextEditingController SellingPriceController = new TextEditingController();
  TextEditingController EndDateController = new TextEditingController();
  TextEditingController LocationController = new TextEditingController();
  TextEditingController CityController = new TextEditingController();
  List<File> uploadingImages = [];
  List<int> deletedImagesIDs = [];
  String _coverImage;
  AsyncMemoizer _memorizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      nameController.text = widget.product.name;
      DescriptionController.text = widget.product.description;
      StartPriceController.text = widget.product.startPrice.toString();
      IncrementController.text = widget.product.minIncrement.toString();
      LocationController.text = widget.product.country;
      CityController.text = widget.product.city;
      fullDate = widget.product.startDate;
    } else {
      var now = DateTime.now();
      fullDate = now.year.toString() +
          "-" +
          now.month.toString() +
          "-" +
          now.day.toString() +
          " " +
          now.hour.toString() +
          ":" +
          now.minute.toString() +
          ":" +
          now.second.toString();
    }
  }

  String userImage =
      "https://cdn0.iconfinder.com/data/icons/avatar-78/128/12-512.png";
  String base64Image;
  var fullDate;
  Future getImage() async {
    if (widget.product == null && uploadingImages.length >= 4) {
      Toast.show(allTranslations.text("Max 4"), context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else if (widget.product != null &&
        uploadingImages.length +
                widget.product.images.length -
                deletedImagesIDs.length >=
            4) {
      Toast.show(allTranslations.text("Max 4"), context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      int max = 0;
      if (widget.product == null) {
        max = 4 - uploadingImages.length;
      } else {
        max = 4 -
            (uploadingImages.length + widget.product.images.length) +
            deletedImagesIDs.length;
      }
      if (max != 0) {
        List<Asset> images = await MultiImagePicker.pickImages(
            maxImages: max,
            enableCamera: true,
            materialOptions: MaterialOptions());
        images.forEach((item) async {
          String dir = (await getApplicationDocumentsDirectory()).path;
          final buffer = (await item.getByteData()).buffer;
          uploadingImages.add((await File(dir + "/" + item.name).writeAsBytes(
              buffer.asUint8List((await item.getByteData()).offsetInBytes,
                  (await item.getByteData()).lengthInBytes))));
          setState(() {});
        });
      }
    }
    setState(() {});
  }

  Future getCoverImage() async {
    List<Asset> image = await MultiImagePicker.pickImages(
        maxImages: 1, enableCamera: true, materialOptions: MaterialOptions());
    if (widget.product != null) {
      String dir = (await getApplicationDocumentsDirectory()).path;
      final buffer = (await image[0].getByteData()).buffer;
      (await File(dir + "/" + image[0].name).writeAsBytes(buffer.asUint8List(
          (await image[0].getByteData()).offsetInBytes,
          (await image[0].getByteData()).lengthInBytes)));

      widget.product.cover = dir + "/" + image[0].name;
    } else {
      String dir = (await getApplicationDocumentsDirectory()).path;
      final buffer = (await image[0].getByteData()).buffer;
      (await File(dir + "/" + image[0].name).writeAsBytes(buffer.asUint8List(
          (await image[0].getByteData()).offsetInBytes,
          (await image[0].getByteData()).lengthInBytes)));
      _coverImage = dir + "/" + image[0].name;
    }
    setState(() {});
  }

  Widget _images() {
    List<Widget> children = [];
    if (widget.product != null) {
      widget.product.images.forEach((item) {
        if (!deletedImagesIDs.contains(item.id)) {
          children.add(SizedBox(
            width: 62,
            height: 62,
            child: Stack(
              children: <Widget>[
                FutureBuilder(
                    future: precacheImage(NetworkImage(item.src), context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Container(
                            width: double.infinity,
                            height: 50,
                            color: Colors.grey);
                      }
                      return FadeInImage(
                        placeholder:
                            AssetImage("lib/assets/images/errorImage.png"),
                        image: NetworkImage(item.src),
                        width: 62,
                        height: 62,
                        fit: BoxFit.contain,
                      );
                    }),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                      onTap: () {
                        deletedImagesIDs.add(item.id);
                        setState(() {});
                      },
                      child: Icon(
                        Icons.close,
                        color: Color(0xffd4d4d4),
                        size: 50,
                      )),
                )
              ],
            ),
          ));
        }
      });
    }

    uploadingImages.forEach((item) {
      children.add(SizedBox(
        width: 62,
        height: 62,
        child: Stack(
          children: <Widget>[
            Image.file(
              item,
              width: 62,
              height: 62,
              fit: BoxFit.contain,
            ),
            Positioned(
              right: 5,
              top: 5,
              child: InkWell(
                  onTap: () {
                    uploadingImages.remove(item);
                    setState(() {});
                  },
                  child: Icon(
                    Icons.close,
                    size: 50,
                    color: Color(0xffd4d4d4),
                  )),
            )
          ],
        ),
      ));
    });
    if ((widget.product == null && uploadingImages.length < 4) ||
        (widget.product != null &&
            widget.product.images.length +
                    uploadingImages.length -
                    deletedImagesIDs.length <
                4)) {
      children.add(InkWell(
        onTap: getImage,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          width: 62,
          height: 62,
          child: Icon(
            Icons.add,
            size: 32,
            color: DataProvider().primary,
          ),
          decoration: ShapeDecoration(
              color: Color(0xffd4d4d4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
        ),
      ));
    }

    return Wrap(
      children: children,
      spacing: 10,
      runSpacing: 10,
    );
  }

  @override
  double hieghtAll = 20.0;
  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: DataProvider().primary),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.product == null
              ? allTranslations.text("Add New Auction")
              : allTranslations.text("Edit Aution"),
          style: TextStyle(color: DataProvider().primary),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: FutureBuilder(
              future: _memorizer.runOnce(() async {
                await MazadProvider().getCategories().then((res) {
                  var result = json.decode(res)["data"];
                  categories = [];

                  result.forEach((item) {
                    categories.add(Category.fromJson(item));
                  });
                });
                if (widget.product != null) {
                  selectedSubCategory = widget.product.subcategory.id;
                  selectedCategory = categories.singleWhere((test) {
                    return test.id == widget.product.parentCategory.id;
                  });
                }
              })
                ..catchError((onError) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => ErrorScreen()));
                }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return CustomErrorWidget();
                  }
                  return ListView(
                    children: <Widget>[
                      Stack(
                        fit: StackFit.passthrough,
                        children: <Widget>[
                          InkWell(
                            onTap: getCoverImage,
                            child: Builder(builder: (
                              context,
                            ) {
                              return FutureBuilder(
                                  future: isNetowrkImageLoadable(),
                                  builder: (context, snapshot) {
                                    if (imageHasError) {
                                      return Container(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                        decoration: BoxDecoration(
                                          color: widget.product.cover == null
                                              ? Color(0xffd4d4d4)
                                              : Colors.transparent,
                                          image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: NetworkImage(
                                                widget.product.cover,
                                              )),
                                        ),
                                        child: _coverImage == null &&
                                                (widget.product == null ||
                                                    widget.product.cover ==
                                                        null)
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.camera_alt,
                                                    size: 40,
                                                    color:
                                                        DataProvider().primary,
                                                  ),
                                                  Text(
                                                    allTranslations
                                                        .text("Add Image"),
                                                    style: TextStyle(
                                                        color: DataProvider()
                                                            .primary),
                                                  )
                                                ],
                                              )
                                            : SizedBox(),
                                      );
                                    } else {
                                      return Container(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                        decoration: buildBoxDecoration(),
                                        child: _coverImage == null &&
                                                (widget.product == null ||
                                                    widget.product.cover ==
                                                        null)
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.camera_alt,
                                                    size: 40,
                                                    color:
                                                        DataProvider().primary,
                                                  ),
                                                  Text(
                                                    allTranslations
                                                        .text("Add Image"),
                                                    style: TextStyle(
                                                        color: DataProvider()
                                                            .primary),
                                                  )
                                                ],
                                              )
                                            : SizedBox(),
                                      );
                                    }
                                  });
                            }),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: InkWell(
                                onTap: () {
                                  widget.product.cover = null;
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Color(0xffd4d4d4),
                                )),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _images(),
                      new Text(
                        allTranslations.text("Product Name"),
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: hieghtAll),
                      buildTextForm(nameController, "Product Name Here", null,
                          null, TextInputType.text),
                      SizedBox(height: hieghtAll),
                      new Text(
                        allTranslations.text("Description"),
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: hieghtAll),
                      buildTextForm(
                          DescriptionController,
                          allTranslations
                              .text("Write product description here ..."),
                          null,
                          null,
                          TextInputType.text,
                          false,
                          true,
                          5),
                      SizedBox(height: hieghtAll),
                      new Text(
                        allTranslations.text("Auction Start Price"),
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: hieghtAll),
                      buildTextForm(
                          StartPriceController,
                          allTranslations.text("Example: 600 USD"),
                          null,
                          null,
                          TextInputType.number),
              
                      SizedBox(height: hieghtAll),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: DataProvider().primary),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: Text(allTranslations.text("Category")),
                              value: selectedCategory,
                              isExpanded: true,
                              onChanged: (value) {
                                selectedCategory = value;
                                selectedSubCategory = null;
                                setState(() {});
                              },
                              items: List.generate(categories.length, (index) {
                                return DropdownMenuItem(
                                  value: categories[index],
                                  child: Text(categories[index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                );
                              }),
                            ),
                          )),
                      if (selectedCategory != null)
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            margin: EdgeInsets.only(top: hieghtAll),
                            decoration: BoxDecoration(
                              border: Border.all(color: DataProvider().primary),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text(allTranslations.text("Subcategory")),
                                isExpanded: true,
                                onChanged: (value) {
                                  selectedSubCategory = value;
                                  setState(() {});
                                },
                                value: selectedSubCategory,
                                items: List.generate(
                                    selectedCategory.children.length, (index) {
                                  return DropdownMenuItem(
                                    value: selectedCategory.children[index].id,
                                    child: Text(
                                        selectedCategory.children[index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  );
                                }),
                              ),
                            )),
                                    SizedBox(height: hieghtAll),
                      new Text(
                        allTranslations.text("Minimum  Increment"),
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: hieghtAll),
                      buildTextForm(IncrementController, "Example: 600 USD",
                          null, null, TextInputType.number),
                      SizedBox(height: hieghtAll),
                      new Text(
                        allTranslations.text("Auction Start Date"),
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: hieghtAll),
                      
                      InkWell(
                        child: buildTextForm(
                            EndDateController,
                            "${fullDate.substring(0, fullDate.lastIndexOf(" "))}",
                            null,
                            Icon(Icons.date_range),
                            null,
                            false,
                            true,
                            1,
                            false),
                        onTap: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime.now().add(Duration(days: 31)),
                              onChanged: (date) {
                            setState(() {
                              var now = DateTime.now();
                              fullDate = date.year.toString() +
                                  "-" +
                                  date.month.toString() +
                                  "-" +
                                  date.day.toString() +
                                  " " +
                                  now.hour.toString() +
                                  ":" +
                                  now.minute.toString() +
                                  ":" +
                                  now.second.toString();
                            });
                          }, onConfirm: (date) {}, locale: LocaleType.en);
                        },
                      ),
                      SizedBox(height: hieghtAll),
                      new Text(
                        allTranslations.text("Location"),
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: hieghtAll),
                      buildTextForm(
                          LocationController,
                          allTranslations.text("Example: Alexandria"),
                          null,
                          null,
                          TextInputType.text),
                      SizedBox(height: hieghtAll),
                      buildTextForm(
                          CityController,
                          allTranslations.text("Example: Egypt"),
                          null,
                          null,
                          TextInputType.text),
                      SizedBox(height: hieghtAll),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width / 1.2,
                child: RaisedButton(
                  child: Text(
                    widget.product == null
                        ? allTranslations.text("Add Auction")
                        : allTranslations.text("Edit Auction"),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    bool close = await ontap();
                    if (close) {
                      Navigator.pop(context);
                    }
                  },
                  color: DataProvider().primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
    if (widget.product != null) {
      return BoxDecoration(
          image: widget.product.cover != null
              ? DecorationImage(
                  image: widget.product.cover.contains("http")
                      ? NetworkImage(widget.product.cover)
                      : FileImage(File(widget.product.cover)),
                  fit: BoxFit.contain)
              : null,
          color: widget.product.cover == null
              ? Color(0xffd4d4d4)
              : Colors.transparent);
    } else {
      return BoxDecoration(
          color: Color(0xffd4d4d4),
          image: _coverImage != null
              ? DecorationImage(
                  image: FileImage(File(_coverImage)), fit: BoxFit.contain)
              : null);
    }
  }

  validate() {
    return DescriptionController.text != null &&
        DescriptionController.text != "" &&
        nameController.text != null &&
        nameController.text != "" &&
        StartPriceController.text != null &&
        StartPriceController.text != "" &&
        IncrementController.text != null &&
        IncrementController.text != "" &&
        fullDate != null &&
        fullDate != "" &&
        LocationController.text != null &&
        LocationController.text != "" &&
        CityController.text != null &&
        CityController.text != "" &&
        selectedCategory != null &&
        selectedSubCategory != null;
  }

  ontap() async {
    if (!validate()) {
      Toast.show(allTranslations.text("insert empty data"), context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return false;
    }
    //this means that i have product and i need to edit it
    if (widget.product != null) {
      bool result = await loadWidget(context, editAuction());
      if (result) {
        Toast.show(allTranslations.text("done"), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        return true;
      } else {
        Toast.show(allTranslations.text("failed"), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        return false;
      }
    } else {
      if (_coverImage == null) {
        Toast.show(allTranslations.text("insert empty data"), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        return false;
      }
      var response = await loadWidget(context, _addAuction());
      if (response["success"] == "false" &&
          response["data"]["message"] ==
              "Sorry You have to create an auction account") {
        var isClose = await nationalIdDialog(context);
        if (!isClose) {
          return await ontap();
        }
        return false;
      } else {
        return true;
      }
    }
  }

  Future _addAuction() async {
    File f = File.fromUri(Uri(path: _coverImage));
    if (f.lengthSync() > 1000000) {
      f = await _compressFile(f);
      f = await FlutterExifRotation.rotateAndSaveImage(path: f.path);
    }
    for (File f in uploadingImages) {
      if (f.lengthSync() > 1000000) {
        f = await _compressFile(f);
        f = await FlutterExifRotation.rotateAndSaveImage(path: f.path);
      }
    }
    var response = await MazadProvider().createAuction(
        nameController.text,
        DescriptionController.text,
        StartPriceController.text,
        IncrementController.text,
        fullDate,
        LocationController.text,
        CityController.text,
        selectedSubCategory,
        f,
        uploadingImages);
    return response;
  }

  Future<bool> editAuction() async {
    await MazadProvider().deleteImages(widget.product.id, deletedImagesIDs);
    File f;
    if (!widget.product.cover.contains("http")) {
      f = File.fromUri(Uri(path: widget.product.cover));
    }
    if (f != null && f.lengthSync() > 1000000) {
      f = await _compressFile(f);
      f = await FlutterExifRotation.rotateAndSaveImage(path: f.path);
    }
    for (File f in uploadingImages) {
      if (f.lengthSync() > 1000000) {
        f = await _compressFile(f);
        f = await FlutterExifRotation.rotateAndSaveImage(path: f.path);
      }
    }
    bool result = await MazadProvider().editProduct(
        widget.product.id,
        nameController.text,
        DescriptionController.text,
        StartPriceController.text,
        IncrementController.text,
        fullDate,
        LocationController.text,
        CityController.text,
        selectedSubCategory,
        f,
        [...uploadingImages]);
    return result;
  }

  isNetowrkImageLoadable() async {
    if (widget == null) {
      return;
    }
    if (widget.product.cover.contains("http")) {
      precacheImage(NetworkImage(widget.product.cover), context,
          onError: (_, __) {
        imageHasError = true;
      });
    }
  }

  Future<File> _compressFile(File file) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      file.absolute.path,
      quality: 88,
    );
    if (result.lengthSync() > 1000000) {
      return _compressFile(result);
    }
    return result;
  }
}
