import 'package:dio/dio.dart';
import 'package:manage_mahasiswa/features/Auth/domain/entities/admin_entity.dart';
import 'package:manage_mahasiswa/features/Auth/data/models/admin_model.dart';

abstract class AdminApiService {
  Future login(String username, String password);
  Future register(AdminEntity data);
  Future<Response?> sendOTP(String email);
  Future verifyOTP(String email, int otpInput);
  Future resendOTP(String email);
}

class AdminApiServiceImpl extends AdminApiService {
  Dio dio = Dio();

  @override
  Future login(String username, String password) async {
    String url = "http://localhost:3000/api/admin/login";

    Map<String, dynamic> queryParams = {
      'username': username,
      'password': password,
    };

    try {
      var response = await dio.post(url, data: queryParams);
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  @override
  Future register(AdminEntity data) async {
    String url = "http://localhost:3000/api/admin/register";

    try {
      var response = await dio.post(url, data: AdminModel.toJson(data));

      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  @override
  Future<Response?> sendOTP(String email) async {
    String url = "http://localhost:3000/api/admin/register/$email/otp";

    try {
      var response = await dio.get(url);

      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  @override
  Future verifyOTP(String email, int otpInput) async {
    String url = "http://localhost:3000/api/admin/register/$email/verify";
    Map<String, int> otp = {"otp": otpInput};

    try {
      var response = await dio.post(url, data: otp);
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  @override
  Future resendOTP(String email) async {
    String url = "http://localhost:3000/api/admin/register/$email/otp";

    try {
      var response = await dio.get(url);
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }
}
