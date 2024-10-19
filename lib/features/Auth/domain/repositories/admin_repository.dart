import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Auth/domain/entities/admin_entity.dart';

abstract class AdminRepository {
  Future<DataState<AdminEntity>> login(String username, String password);
  Future<DataState<AdminEntity>> register(AdminEntity data);
  Future<DataState<String>> sendOTP(String email);
  Future<DataState<Map<String, dynamic>>> resendOTP(String email);
  Future<DataState<Map<String, dynamic>>> verifyOTP(String email, int otpInput);
}
