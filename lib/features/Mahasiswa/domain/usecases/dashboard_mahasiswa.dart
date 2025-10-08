import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/repositories/mahasiswa_repository.dart';

class DashboardMahasiswaUseCase {
  final MahasiswaRepository _mahasiswaRepository;
  const DashboardMahasiswaUseCase(this._mahasiswaRepository);

  Future<DataState<Map<String, dynamic>>> execute() async {
    return await _mahasiswaRepository.getDashboardMahasiswa();
  }
}
