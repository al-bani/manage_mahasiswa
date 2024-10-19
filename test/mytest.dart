import 'package:manage_mahasiswa/features/Auth/data/datasources/admin_api_service.dart';

void main() async {
  final AdminApiService mhs = AdminApiServiceImpl();

  var response = await mhs.login("albani", "albani123");

  print(response);
}
