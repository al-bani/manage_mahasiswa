import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';

abstract class MahasiswaApiService {
  Future getAllMahasiswa(String token, int adminId, bool isFirstTimePage);
  Future getDetailMahasiswa(String token, int adminId, int nim);
  Future deleteMahasiswa(String token, int adminId, int nim);
  Future createMahasiswa(MahasiswaEntity mhs, String token, int adminId);
  Future updateMahasiswa(
      MahasiswaEntity mhs, String token, int adminId, int nim);
  Future searchMahasiswa(String token, int adminId, String search);
  Future filterMahasiswa(
      String token, int adminId, Map<String, dynamic> filter);
  Future getDashboardMahasiswa();
}

class MahasiswaApiServiceImpl extends MahasiswaApiService {
  Dio dio = Dio()
    ..options.connectTimeout = const Duration(seconds: 10)
    ..options.receiveTimeout = const Duration(seconds: 10)
    ..options.sendTimeout = const Duration(seconds: 10)
    ..interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

  @override
  Future<Response> getAllMahasiswa(
      String token, int adminId, bool isFirstTimePage) async {
    String url = "${dotenv.env['API_URL']}/api/mahasiswa/all";
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
    String url = "${dotenv.env['API_URL']}/api/mahasiswa/$nim";
    dio.options.headers['Authorization'] = token;
    Map<String, dynamic> queryParams = {
      'admin_id': adminId,
    };

    try {
      var response = await dio.get(url, data: queryParams);
      return response;
    } on DioException catch (e) {
      return e.response!;
    }
  }

  @override
  Future<Response> deleteMahasiswa(String token, int adminId, int nim) async {
    String url = "${dotenv.env['API_URL']}/api/mahasiswa/delete/$nim";
    dio.options.headers['Authorization'] = token;
    Map<String, dynamic> queryParams = {
      'admin_id': adminId,
    };

    try {
      var response = await dio.delete(url, data: queryParams);

      return response;
    } on DioException catch (e) {
      return e.response!;
    }
  }

  @override
  Future<Response> createMahasiswa(
      MahasiswaEntity mhs, String token, int adminId) async {
    String url = "${dotenv.env['API_URL']}/api/mahasiswa/create";
    dio.options.headers['Authorization'] = token;
    Map<String, dynamic> queryParams = {
      "admin_id": adminId,
      "name": mhs.name!,
      "province": mhs.province!,
      "city": mhs.city!,
      "district": mhs.district!,
      "subdistrict": mhs.subdistrict!,
      "email": mhs.email!,
      "phone_number": mhs.phoneNumber!,
      "fakultas": mhs.fakultas!,
      "jurusan": mhs.jurusan!,
      "date_of_birth": mhs.birth!,
      "gender": mhs.gender!,
      "image": mhs.image!
    };

    try {
      var response = await dio.post(url, data: queryParams);

      return response;
    } on DioException catch (e) {
      return e.response!;
    }
  }

  @override
  Future<Response> updateMahasiswa(
      MahasiswaEntity mhs, String token, int adminId, int nim) async {
    String url = "${dotenv.env['API_URL']}/api/mahasiswa/update/$nim";
    dio.options.headers['Authorization'] = token;
    Map<String, dynamic> queryParams = {
      "admin_id": adminId,
      "name": mhs.name!,
      "province": mhs.province!,
      "city": mhs.city!,
      "district": mhs.district!,
      "subdistrict": mhs.subdistrict!,
      "email": mhs.email!,
      "phone_number": mhs.phoneNumber!,
      "fakultas": mhs.fakultas!,
      "jurusan": mhs.jurusan!,
      "birth": mhs.birth!,
      "gender": mhs.gender!,
      "image": mhs.image!
    };

    try {
      var response = await dio.put(url, data: queryParams);

      return response;
    } on DioException catch (e) {
      return e.response!;
    }
  }

  @override
  Future<Response> searchMahasiswa(
      String token, int adminId, String search) async {
    String url = "${dotenv.env['API_URL']}/api/mahasiswa/search";
    dio.options.headers['Authorization'] = token;

    Map<String, dynamic> rawParameter = {'admin_id': adminId};

    try {
      var response = await dio.get(url,
          queryParameters: {'key': search}, data: rawParameter);
      return response;
    } on DioException catch (e) {
      return e.response!;
    }
  }

  @override
  Future<Response> filterMahasiswa(
      String token, int adminId, Map<String, dynamic> filter) async {
    String url = "${dotenv.env['API_URL']}/api/mahasiswa/filter";
    dio.options.headers['Authorization'] = token;

    filter['admin_id'] = adminId;

    try {
      var response = await dio.post(url, data: filter);
      return response;
    } on DioException catch (e) {
      return e.response!;
    }
  }

  @override
  Future<Response> getDashboardMahasiswa() async {
    String url = "${dotenv.env['API_URL']}/api/mahasiswa/dashboard";

    try {
      var response = await dio.get(url);

      return response;
    } on DioException catch (e) {
      return Response(
        requestOptions: e.requestOptions,
        statusCode: 599,
        data: {
          "msg": e.message ?? "Network error",
          "type": e.type.toString(),
        },
      );
    }
  }
}
