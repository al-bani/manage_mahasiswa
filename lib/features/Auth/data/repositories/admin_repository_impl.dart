import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/features/Auth/data/datasources/admin_api_service.dart';
import 'package:manage_mahasiswa/features/Auth/data/models/admin_model.dart';
import 'package:manage_mahasiswa/features/Auth/domain/entities/admin_entity.dart';
import 'package:manage_mahasiswa/features/Auth/domain/repositories/admin_repository.dart';

class AdminRepositoryImpl extends AdminRepository {
  final AdminApiService _adminApiService;
  AdminRepositoryImpl(this._adminApiService);

  @override
  Future<DataState<AdminEntity>> login(String username, String password) async {
    final response = await _adminApiService.login(username, password);
    if (response == null) {
      return const DataFailed({"msg": "Tidak ada respons dari server"});
    }

    final Map<String, dynamic> result =
        (response.data is Map<String, dynamic>) ? response.data : {};

    if (response.statusCode == 200 && result.containsKey('result')) {
      final AdminModel data = AdminModel.fromJson(result['result']);
      return DataSuccess(data);
    }

    return DataFailed(result.isNotEmpty ? result : {"msg": "Login gagal"});
  }

  @override
  Future<DataState<AdminEntity>> register(AdminEntity data) async {
    final response = await _adminApiService.register(data);
    if (response == null) {
      return const DataFailed({"msg": "Tidak ada respons dari server"});
    }

    final Map<String, dynamic> result =
        (response.data is Map<String, dynamic>) ? response.data : {};

    if (response.statusCode == 200 && result.containsKey('result')) {
      final AdminModel admin = AdminModel.fromJson(result['result']);
      return DataSuccess(admin);
    }

    return DataFailed(result.isNotEmpty ? result : {"msg": "Register gagal"});
  }

  @override
  Future<DataState<String>> sendOTP(String email) async {
    final response = await _adminApiService.sendOTP(email);
    if (response == null) {
      return const DataFailed({"msg": "Tidak ada respons dari server"});
    }

    final Map<String, dynamic> result =
        (response.data is Map<String, dynamic>) ? response.data : {};
    final String message = (result["msg"] ?? "").toString();

    if (response.statusCode == 200 && message.isNotEmpty) {
      return DataSuccess(message);
    }

    return DataFailed(
        result.isNotEmpty ? result : {"msg": "Gagal mengirim OTP"});
  }

  @override
  Future<DataState<Map<String, dynamic>>> resendOTP(String email) async {
    final response = await _adminApiService.resendOTP(email);
    if (response == null) {
      return const DataFailed({"msg": "Tidak ada respons dari server"});
    }

    final Map<String, dynamic> result =
        (response.data is Map<String, dynamic>) ? response.data : {};

    if (response.statusCode == 200) {
      return DataSuccess(result);
    }

    return DataFailed(result.isNotEmpty ? result : {"msg": "Gagal resend OTP"});
  }

  @override
  Future<DataState<Map<String, dynamic>>> verifyOTP(String email, int otpInput) async {
    final response = await _adminApiService.verifyOTP(email, otpInput);
    if (response == null) {
      return const DataFailed({"msg": "Tidak ada respons dari server"});
    }

    final Map<String, dynamic> result =
        (response.data is Map<String, dynamic>) ? response.data : {};

    if (response.statusCode == 200) {
      return DataSuccess(result);
    }

    return DataFailed(
        result.isNotEmpty ? result : {"msg": "Verifikasi OTP gagal"});
  }
}
