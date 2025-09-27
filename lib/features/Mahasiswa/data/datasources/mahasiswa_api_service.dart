import 'package:dio/dio.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';

abstract class MahasiswaApiService {
  Future getAllMahasiswa(String token, int adminId, bool isFirstTimePage);
  Future getDetailMahasiswa(String token, int adminId, int nim);
  Future deleteMahasiswa(String token, int adminId, int nim);
  Future createMahasiswa(MahasiswaEntity mhs, String token, int adminId);
  Future updateMahasiswa(
      MahasiswaEntity mhs, String token, int adminId, int nim);

  searchMahasiswa(String token, int adminId, String search) {}
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
    String url = "http://localhost:3000/api/mahasiswa/$nim";
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
    String url = "http://localhost:3000/api/mahasiswa/delete/$nim";
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
    String url = "http://localhost:3000/api/mahasiswa/create";
    dio.options.headers['Authorization'] = token;
    Map<String, dynamic> queryParams = {
      "admin_id": adminId,
      "name": mhs.name!,
      "asal": mhs.asal!,
      "email": mhs.email!,
      "phone_number": mhs.phoneNumber!,
      "fakultas": mhs.fakultas!,
      "jurusan": mhs.jurusan!,
      "date_of_birth": mhs.dateOfBirth!,
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
    String url = "http://localhost:3000/api/mahasiswa/update/$nim";
    dio.options.headers['Authorization'] = token;
    Map<String, dynamic> queryParams = {
      "admin_id": adminId,
      "name": mhs.name!,
      "asal": mhs.asal!,
      "email": mhs.email!,
      "phone_number": mhs.phoneNumber!,
      "fakultas": mhs.fakultas!,
      "jurusan": mhs.jurusan!,
      "date_of_birth": mhs.dateOfBirth!,
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
  Future<Response> searchMahasiswa(String token, int adminId, String search) async {
    String url = "http://localhost:3000/api/mahasiswa/search";
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
}
