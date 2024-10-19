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
      Map<String, dynamic> dataBody = response.data;
      List<MahasiswaModel> data =
          MahasiswaModel.fromJsonList(dataBody["result"]);

      return DataSuccess(data);
    } else {

      return DataFailed(result);
    }
  }
}
