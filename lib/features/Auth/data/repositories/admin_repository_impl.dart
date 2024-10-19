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
    var response = await _adminApiService.login(username, password);
    Map<String, dynamic> result = response.data;

    if (result.containsKey('result')) {
      AdminModel data = AdminModel.fromJson(result['result']);
      return DataSuccess(data);
    } else {
      return DataFailed(result);
    }
  }

  @override
  Future<DataState<AdminEntity>> register(AdminEntity data) async {
    var response = await _adminApiService.register(data);
    Map<String, dynamic> result = response.data;
    if (result.containsKey('result')) {
      AdminModel data = AdminModel.fromJson(result['result']);
      return DataSuccess(data);
    } else {
      return DataFailed(result);
    }
  }

  @override
  Future<DataState<String>> sendOTP(String email) async {
    var response = await _adminApiService.sendOTP(email);
    Map<String, dynamic> result = response!.data;
    String message = result["msg"];

    if (response.statusCode == 200) {
      return DataSuccess(message);
    } else if (response.statusCode == 400) {
      return DataFailed(result);
    } else {
      return DataFailed(result);
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> resendOTP(String email) async {
    var response = await _adminApiService.resendOTP(email);
    Map<String, dynamic> result = response!.data;

    if (response.statusCode == 200) {
      return DataSuccess(result);
    } else if (response.statusCode == 400) {
      return DataFailed(result);
    } else {
      return DataFailed(result);
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> verifyOTP(
      String email, int otpInput) async {
    var response = await _adminApiService.verifyOTP(email, otpInput);
    Map<String, dynamic> result = response!.data;

    if (response.statusCode == 200) {
      return DataSuccess(result);
    } else if (response.statusCode == 400) {
      return DataFailed(result);
    } else {
      return DataFailed(result);
    }
  }
}
