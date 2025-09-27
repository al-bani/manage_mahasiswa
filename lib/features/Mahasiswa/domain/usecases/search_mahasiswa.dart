import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/entities/mahasiswa_entity.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/domain/repositories/mahasiswa_repository.dart';

class SearchMahasiswaUseCase {
  final MahasiswaRepository _mahasiswaRepository;
  const SearchMahasiswaUseCase(this._mahasiswaRepository);

  Future<DataState<List<MahasiswaEntity>>> execute(String token, int adminId, String search) async {
    return await _mahasiswaRepository.searchMahasiswa(
        token, adminId, search);
  }
}
