import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/repositories/mahasiswa_repository.dart';

class CreateMahasiswaUseCase {
  final MahasiswaRepository _mahasiswaRepository;
  const CreateMahasiswaUseCase(this._mahasiswaRepository);

  Future<DataState<MahasiswaEntity>> execute(
      MahasiswaEntity mhs, token, int adminId) async {
    return await _mahasiswaRepository.createMahasiswa(mhs, adminId, token);
  }
}
