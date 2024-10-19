import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Auth/domain/repositories/admin_repository.dart';

class OtpUsecase {
  final AdminRepository _adminRepository;
  const OtpUsecase(this._adminRepository);

  Future<DataState<String>> sendOtpExecute(String email) async {
    return await _adminRepository.sendOTP(email);
  }

  Future<DataState<Map<String, dynamic>>> resendOtpExecute(String email) async {
    return await _adminRepository.resendOTP(email);
  }

  Future<DataState<Map<String, dynamic>>> verifyOTPExecute(
      String email, int otpInput) async {
    return await _adminRepository.verifyOTP(email, otpInput);
  }
}
