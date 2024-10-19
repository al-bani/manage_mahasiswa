import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/repositories/mahasiswa_repository.dart';

class GetMahasiswaDetailUseCase {
  final MahasiswaRepository _mahasiswaRepository;
  const GetMahasiswaDetailUseCase(this._mahasiswaRepository);

  Future<DataState<MahasiswaEntity>> execute(
      String token, int adminId, int nim) async {
    return await _mahasiswaRepository.getMahasiswa(token, adminId, nim);
  }
}
