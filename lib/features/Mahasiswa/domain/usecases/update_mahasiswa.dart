import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/repositories/mahasiswa_repository.dart';

class UpdateMahasiswaUseCase {
  final MahasiswaRepository _mahasiswaRepository;
  const UpdateMahasiswaUseCase(this._mahasiswaRepository);

  Future<DataState<MahasiswaEntity>> execute(
      MahasiswaEntity mhs, String token, int adminId, int nim) async {
    return await _mahasiswaRepository.updateMahasiswa(mhs, token, adminId, nim);
  }
}
