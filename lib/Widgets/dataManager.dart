import 'dart:io';
import 'dart:async';
import 'package:big/model/Productsmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DatabaseManager {
  static Database _db;
  final String productTable = 'ProductTable';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnDescription = 'description';
  final String columnImageUrl = 'imageUrl';
  final String columnPrice = 'price';
  final String columnOffer = 'offer';
  final String columnIsNew = 'isNew';
  final String columnProductID = 'productID';

  final String mallTable = "MallTable";
  final String storeTable = "StoreTable";

  final String columnID = 'id';
  final String columnMallID = 'mall_id';

  final String columnName = 'name';
  final String columnlocation = 'location';
  final String columnOpen_time = 'open_time';
  final String columnClose_time = 'close_time';
  final String columnMap = 'map';
  final String columnCover = "cover";
  final String columnCity = "city";
  final String mobile = "mobile";
  final String category = "category";
    final String rating = "rating";


  final String wuzzefTable = "Wuzzef";
  final String wuzzefid = "id";
  final String wuzzefTitle = "title";
  final String wuzzefDescription = "description";
  final String wuzzefCounrty = "country";
  final String wuzzefCity = "city";
  final String wuzzefjobType = "jobType";
  final String wuzzefImageUrl = "imageUrl";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await intDB();
    return _db;
  }

  intDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'mydb5.db');
    var myOwnDB = await openDatabase(path, version: 8, onCreate: _onCreate);
    return myOwnDB;
  }

  void _onCreate(Database db, int newVersion) async {
    var sql;
    sql = "CREATE TABLE $productTable ($columnId INTEGER PRIMARY KEY,"
        " $columnTitle TEXT, $columnDescription TEXT,  $columnImageUrl TEXT,"
        " $columnPrice TEXT, $columnOffer TEXT,  $columnIsNew INTEGER,$columnProductID INTEGER )";
    await db.execute(sql);

    sql = "CREATE TABLE $mallTable ($columnID INTEGER PRIMARY KEY,"
        " $columnName TEXT, $columnlocation TEXT,  $columnOpen_time TEXT,"
        " $columnClose_time TEXT, $columnMap TEXT,  $columnCover TEXT,$columnCity TEXT,$rating Real )";
    await db.execute(sql);

    sql = "CREATE TABLE $storeTable ($columnID INTEGER PRIMARY KEY,"
        " $columnName TEXT, $columnlocation TEXT,  $columnOpen_time TEXT,"
        " $columnClose_time TEXT, $columnCover TEXT,  $category TEXT,$mobile TEXT , $columnMallID INTEGER)";
    await db.execute(sql);

    sql = "CREATE TABLE $wuzzefTable ($wuzzefid INTEGER PRIMARY KEY,"
        " $wuzzefTitle TEXT, $wuzzefDescription TEXT,  $wuzzefCounrty TEXT,"
        " $wuzzefCity TEXT, $wuzzefImageUrl TEXT,  $wuzzefjobType TEXT)";
    await db.execute(sql);
  }

  Future<int> saveProduct(Product product) async {
    var dbClient = await db;
    int result = await dbClient.insert("$productTable", product.toMap());
    return result;
  }

  Future<List> getAllProducts() async {
    var dbClient = await db;
    var sql = "SELECT * FROM $productTable";
    List result = await dbClient.rawQuery(sql);
    return result.toList();
  }

  //get custom product by id
  Future<Product> getCustomProduct(int id) async {
    var dbClient = await db;
    var sql = "SELECT * FROM $productTable WHERE $columnProductID = $id";
    var result = await dbClient.rawQuery(sql);

    if (result.length == 0) return null;
    return new Product.fromMap(result.first);
  }

  Future<int> getCount() async {
    var dbClient = await db;
    var sql = "SELECT COUNT(*) FROM $productTable";

    return Sqflite.firstIntValue(await dbClient.rawQuery(sql));
  }

  Future<int> deleteProduct(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(productTable, where: "$columnProductID = ?", whereArgs: [id]);
  }

  void clearAllProduct() async {
    var dbClient = await db;
    await dbClient.delete(productTable);
  }

  getallRows(String tableName) async {
    var dbClient = await db;
    return await dbClient.query(tableName);
  }

  insertData(String tableName, Map<String, dynamic> obj) async {
    var dbClient = await db;
    return await dbClient.insert(tableName, obj);
  }

  deleteItem(String tableName, int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  getItem(String tableName, int id) async {
    var dbClient = await db;
    return await dbClient.query(tableName, where: "id = ?", whereArgs: [id]);
  }
}
