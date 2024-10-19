import 'package:manage_mahasiswa/features/Auth/domain/entities/admin_entity.dart';

class AdminModel extends AdminEntity {
  const AdminModel({
    super.id,
    super.username,
    super.email,
    super.password,
    super.token,
  });

  factory AdminModel.fromJson(Map<String, dynamic> data) {
    return AdminModel(
      id: data["id"] as int?,
      username: data["username"] as String?,
      email: data["email"] as String?,
      password: data["password"] as String?,
      token: data['token'] as String?,
    );
  }

  static Map<String, dynamic> toJson(AdminEntity data) {
    return {
      'id': data.id,
      'username': data.username,
      'email': data.email,
      'password': data.password,
      'token': data.token,
    };
  }
}
