import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/repositories/mahasiswa_repository.dart';

class FilterMahasiswaUseCase {
  final MahasiswaRepository _mahasiswaRepository;
  const FilterMahasiswaUseCase(this._mahasiswaRepository);

  Future<DataState<List<MahasiswaEntity>>> execute(
      String token, int adminId, Map<String, dynamic> filter) async {
    return await _mahasiswaRepository.filterMahasiswa(token, adminId, filter);
  }
}
