import 'package:dio/dio.dart';

abstract class MahasiswaApiService {
  Future getAllMahasiswa(String token, int adminId, bool isFirstTimePage);
}

class MahasiswaApiServiceImpl extends MahasiswaApiService {
  Dio dio = Dio();

  @override
  Future<Response> getAllMahasiswa(String token, int adminId, bool isFirstTimePage) async {
    String url = "http://localhost:3000/api/mahasiswa/all";
    dio.options.headers['Authorization'] = token;
    Map<String, dynamic> queryParams = {
      'admin_id': adminId,
      'is_first_time' : isFirstTimePage
    };

    try {
      var response = await dio.post(url, data: queryParams);
      return response;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }
}