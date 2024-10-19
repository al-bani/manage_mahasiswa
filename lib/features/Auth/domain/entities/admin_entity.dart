import 'package:equatable/equatable.dart';

class AdminEntity extends Equatable {
  final int? id;
  final String? username;
  final String? email;
  final String? password;
  final String? token;

  const AdminEntity({
    this.id,
    this.username,
    this.email,
    this.password,
    this.token,
  });

  @override
  List<Object?> get props {
    return [id, username, email, password, token];
  }
}
