import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/repositories/mahasiswa_repository.dart';

class DeleteMahasiswaUseCase {
  final MahasiswaRepository _mahasiswaRepository;
  const DeleteMahasiswaUseCase(this._mahasiswaRepository);

  Future<DataState<int>> execute(String token, int adminId, int nim) async {
    return await _mahasiswaRepository.deleteMahasiswa(token, adminId, nim);
  }
}
