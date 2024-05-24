import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart';
import 'dart:io';

class DataBaseHelper {
  static DataBaseHelper? _dataBaseHelper;
  static Database? _database;

  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper._internal();
      return _dataBaseHelper!;
    }
    return _dataBaseHelper!;
  }

  DataBaseHelper._internal();

  Future<Database> _getDataBase() async {
    // ignore: prefer_conditional_assignment
    if (_database == null) {
      _database = await _initializeDatabase();
    }
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    var lock = Lock();
    late Database _db;

    await lock.synchronized(() async {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, "appDB.db");
      print("Oluşturulacak DB'nin yolu: $path");
      var file = File(path);

      // Dosyanın varlığını kontrol et
      if (!await file.exists()) {
        // Asset'ten kopyala
        ByteData data = await rootBundle.load(join("assets/db", "ebeveyn.db"));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes);
      }

      // Veritabanını aç
      _db = await openDatabase(path);
    });

    return _db;
  }

  isimleriGetir() async {
    var db = await _getDataBase();
    var sonuc = await db.query("Ogrenci");
    print(sonuc);

    // var ekleme = await db.insert("Ogrenci",
    //     {"ad": "fatih", "soyAd": "fetih", "EbeynId": 1, "OgretmenId": 1}
    //     );
    // var sonuc2 = await db.query("Ogrenci");
    // print(sonuc2);
  }
}
