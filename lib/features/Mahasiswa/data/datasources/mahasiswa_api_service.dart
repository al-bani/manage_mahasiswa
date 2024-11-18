import 'package:dio/dio.dart';

abstract class MahasiswaApiService {
  Future getAllMahasiswa(String token, int adminId, bool isFirstTimePage);
  Future getDetailMahasiswa(String token, int adminId, int nim);
  Future deleteMahasiswa(String token, int adminId, int nim);
}

class MahasiswaApiServiceImpl extends MahasiswaApiService {
  Dio dio = Dio();

  @override
  Future<Response> getAllMahasiswa(
      String token, int adminId, bool isFirstTimePage) async {
    String url = "http://localhost:3000/api/mahasiswa/all";
    dio.options.headers['Authorization'] = token;
    Map<String, dynamic> queryParams = {
      'admin_id': adminId,
      'is_first_time': isFirstTimePage
    };

    try {
      var response = await dio.post(url, data: queryParams);
      return response;
    } on DioException catch (e) {
      return e.response!;
 
    }
  }

  @override
  Future<Response> getDetailMahasiswa(
      String token, int adminId, int nim) async {
    String url = "http://localhost:3000/api/mahasiswa/${nim}";
    dio.options.headers['Authorization'] = token;
    Map<String, dynamic> queryParams = {
      'admin_id': adminId,
    };

    try {
      var response = await dio.get(url, data: queryParams);
      return response;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  @override
  Future<Response> deleteMahasiswa(String token, int adminId, int nim) async {
    String url = "http://localhost:3000/api/mahasiswa/delete/${nim}";
    dio.options.headers['Authorization'] = token;
    Map<String, dynamic> queryParams = {
      'admin_id': adminId,
    };

    try {
      var response = await dio.delete(url, data: queryParams);
      return response;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }
}
