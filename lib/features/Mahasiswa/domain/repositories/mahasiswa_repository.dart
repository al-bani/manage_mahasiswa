import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';

abstract class MahasiswaRepository {
  Future<DataState<List<MahasiswaEntity>>> getAllMahasiswa(
      String token, int adminId, bool isFirstPage);
  Future<DataState<MahasiswaEntity>> getMahasiswa(
      String token, int adminId, int nim);
  Future<DataState<int>> deleteMahasiswa(String token, int adminId, int nim);
  Future<DataState<MahasiswaEntity>> createMahasiswa(
      MahasiswaEntity mhs, int adminId, String token);
  Future<DataState<MahasiswaEntity>> updateMahasiswa(
      MahasiswaEntity mhs, String token, int adminId, int nim);
  Future<DataState<List<MahasiswaEntity>>> searchMahasiswa(
      String token, int adminId, String search);
  Future<DataState<List<MahasiswaEntity>>> filterMahasiswa(
      String token, int adminId, Map<String, dynamic> filter);
}
