import 'package:dio/dio.dart';
import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/data/datasources/mahasiswa_api_service.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/data/models/mahasiswa.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/repositories/mahasiswa_repository.dart';

class MahasiswaRepositoryImpl extends MahasiswaRepository {
  final MahasiswaApiService _mahasiswaApiService;

  MahasiswaRepositoryImpl(this._mahasiswaApiService);

  @override
  Future<DataState<List<MahasiswaEntity>>> getAllMahasiswa(
      String token, int adminId, bool isFirstPage) async {
    Response response =
        await _mahasiswaApiService.getAllMahasiswa(token, adminId, isFirstPage);

    Map<String, dynamic> result = response.data;

    if (result.containsKey('result')) {
      List<MahasiswaModel> data = MahasiswaModel.fromJsonList(result["result"]);

      return DataSuccess(data);
    } else {
      return DataFailed(result);
    }
  }

  @override
  Future<DataState<List<MahasiswaEntity>>> searchMahasiswa(
      String token, int adminId, String search) async {
    Response response =
        await _mahasiswaApiService.searchMahasiswa(token, adminId, search);

    if (response.statusCode == 404) {
      return DataFailed(response.data);
    }
    Map<String, dynamic> result = response.data;

    if (result.containsKey('result')) {
      List<MahasiswaModel> data = MahasiswaModel.fromJsonList(result["result"]);

      return DataSuccess(data);
    } else {
      return DataFailed(result);
    }
  }

  @override
  Future<DataState<MahasiswaEntity>> getMahasiswa(
      String token, int adminId, int nim) async {
    Response response =
        await _mahasiswaApiService.getDetailMahasiswa(token, adminId, nim);
    Map<String, dynamic> result = response.data;

    if (result.containsKey('result')) {
      Map<String, dynamic> dataBody = response.data;
      MahasiswaModel data = MahasiswaModel.fromJson(dataBody["result"]);

      return DataSuccess(data);
    } else {
      return DataFailed(result);
    }
  }

  @override
  Future<DataState<int>> deleteMahasiswa(
      String token, int adminId, int nim) async {
    Response response =
        await _mahasiswaApiService.deleteMahasiswa(token, adminId, nim);

    if (response.statusCode == 200) {
      return const DataSuccess(200);
    } else {
      Map<String, dynamic> result = response.data;
      return DataFailed(result);
    }
  }

  @override
  Future<DataState<MahasiswaEntity>> createMahasiswa(
      MahasiswaEntity mhs, int adminId, String token) async {
    Response response =
        await _mahasiswaApiService.createMahasiswa(mhs, token, adminId);

    if (response.statusCode == 200) {
      Map<String, dynamic> result = response.data;
      MahasiswaModel data = MahasiswaModel.fromJson(result["result"]);

      return DataSuccess(data);
    } else {
      Map<String, dynamic> result = response.data;
      return DataFailed(result);
    }
  }

  @override
  Future<DataState<MahasiswaEntity>> updateMahasiswa(
      MahasiswaEntity mhs, String token, int adminId, int nim) async {
    Response response =
        await _mahasiswaApiService.updateMahasiswa(mhs, token, adminId, nim);

    if (response.statusCode == 200) {
      Map<String, dynamic> result = response.data;
      MahasiswaModel data = MahasiswaModel.fromJson(result["result"]);

      return DataSuccess(data);
    } else {
      Map<String, dynamic> result = response.data;
      return DataFailed(result);
    }
  }
}
