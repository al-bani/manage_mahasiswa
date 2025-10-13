import 'dart:convert';

import 'package:manage_mahasiswa/features/Auth/data/models/admin_model.dart';
import 'package:manage_mahasiswa/features/Auth/domain/entities/admin_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<bool> setLoginStatus(AdminEntity adminData) async {
  final prefs = await SharedPreferences.getInstance();
  String adminJson = jsonEncode(AdminModel.toJson(adminData));
  await prefs.setString('admin', adminJson);
  await prefs.setBool('isLoggedIn', true);

  return true;
}

Future<AdminEntity?> getAdminData() async {
  final prefs = await SharedPreferences.getInstance();
  String? adminJson = prefs.getString('admin');

  if (adminJson != null) {
    Map<String, dynamic> adminMap = jsonDecode(adminJson);
    return AdminModel.fromJson(adminMap);
  }

  return null;
}

Future<bool> getLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

class DBRegional {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'regional.db');

    // Cek apakah database sudah ada dan valid
    final exists = await databaseExists(path);
    bool needCopy = false;

    if (!exists) {
      print("DEBUG: Database tidak ada, perlu copy dari assets");
      needCopy = true;
    } else {
      // Validasi database yang ada
      try {
        final tempDb = await openDatabase(path, readOnly: true);
        final tables = await tempDb.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='desa'");
        await tempDb.close();

        if (tables.isEmpty) {
          print(
              "DEBUG: Database ada tapi tabel desa tidak ditemukan, perlu copy ulang");
          needCopy = true;
        } else {
          print("DEBUG: Database sudah valid, tidak perlu copy");
        }
      } catch (e) {
        print("DEBUG: Error validasi database: $e, perlu copy ulang");
        needCopy = true;
      }
    }

    // Copy database hanya jika diperlukan
    if (needCopy) {
      print("DEBUG: Menyalin database dari assets...");
      ByteData data = await rootBundle.load('assets/regional.db');
      final bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      print("DEBUG: Database berhasil disalin ke: $path");
    }

    final db = await openDatabase(path, readOnly: true);

    // Debug: verifikasi final
    try {
      final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='desa'");
      print("DEBUG: Tabel desa ditemukan: ${tables.length > 0}");
      if (tables.length > 0) {
        final count = await db.rawQuery("SELECT COUNT(*) as count FROM desa");
        print("DEBUG: Jumlah data desa: ${count.first['count']}");
      }
    } catch (e) {
      print("DEBUG: Error checking desa table: $e");
    }

    return db;
  }

  static Future<List<Map<String, dynamic>>> getProvinsi() async {
    final db = await database;
    return await db.query('provinsi', orderBy: 'name ASC');
  }

  static Future<List<Map<String, dynamic>>> getKabupaten(
      String provCode) async {
    final db = await database;
    return await db.query(
      'kabupaten',
      where: 'parent_code = ?',
      whereArgs: [provCode],
      orderBy: 'name ASC',
    );
  }

  static Future<List<Map<String, dynamic>>> getKecamatan(String kabCode) async {
    final db = await database;
    return await db.query(
      'kecamatan',
      where: 'parent_code = ?',
      whereArgs: [kabCode],
      orderBy: 'name ASC',
    );
  }

  static Future<List<Map<String, dynamic>>> getDesa(String kecCode) async {
    final db = await database;
    print("DEBUG: Mencari desa untuk kecamatan: $kecCode");

    try {
      final result = await db.query(
        'desa',
        where: 'parent_code = ?',
        whereArgs: [kecCode],
        orderBy: 'name ASC',
      );
      print("DEBUG: Ditemukan ${result.length} desa untuk kecamatan $kecCode");
      return result;
    } catch (e) {
      print("DEBUG: Error query desa: $e");
      rethrow;
    }
  }
}
