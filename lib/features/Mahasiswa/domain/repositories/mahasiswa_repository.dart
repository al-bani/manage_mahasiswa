import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';

abstract class MahasiswaRepository {
  Future<DataState<List<MahasiswaEntity>>> getAllMahasiswa(String token, int adminId, bool isFirstPage);
  Future<DataState<MahasiswaEntity>> getMahasiswa(String token, int adminId, int nim);
}
