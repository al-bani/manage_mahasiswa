import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/repositories/mahasiswa_repository.dart';

class GetMahasiswaAllUseCase {
  final MahasiswaRepository _mahasiswaRepository;
  const GetMahasiswaAllUseCase(this._mahasiswaRepository);

  Future<DataState<List<MahasiswaEntity>>> execute(
      String token, int adminId, bool isFirstPage) async {
    return await _mahasiswaRepository.getAllMahasiswa(
        token, adminId, isFirstPage);
  }
}
