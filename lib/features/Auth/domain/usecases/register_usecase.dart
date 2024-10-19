import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Auth/domain/entities/admin_entity.dart';
import 'package:manage_mahasiswa/features/Auth/domain/repositories/admin_repository.dart';

class RegisterUsecase {
  final AdminRepository _adminRepository;
  const RegisterUsecase(this._adminRepository);

  Future<DataState<AdminEntity>> executeRegister(AdminEntity data) async {
    return await _adminRepository.register(data);
  }
}
