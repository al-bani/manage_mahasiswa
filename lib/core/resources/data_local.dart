import 'dart:convert';

import 'package:manage_mahasiswa/features/Auth/data/models/admin_model.dart';
import 'package:manage_mahasiswa/features/Auth/domain/entities/admin_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
