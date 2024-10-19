import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Auth/domain/entities/admin_entity.dart';
import 'package:manage_mahasiswa/features/Auth/domain/repositories/admin_repository.dart';

class LoginUseCase {
  final AdminRepository _adminRepository;
  const LoginUseCase(this._adminRepository);

  Future<DataState<AdminEntity>> executeLogin(
      String username, String password) async {
    return await _adminRepository.login(username, password);
  }
}
