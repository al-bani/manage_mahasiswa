import 'package:equatable/equatable.dart';
import 'package:manage_mahasiswa/features/Auth/domain/entities/admin_entity.dart';

abstract class AuthState extends Equatable {
  final AdminEntity? admin;
  final Map<String, dynamic>? error;
  final Map<String, dynamic>? data;
  final String? msg;
  final String? passwordNotValid;

  const AuthState(
      {this.admin, this.error, this.msg, this.passwordNotValid, this.data});

  @override
  List<Object?> get props => [admin, error];
}

class RemoteAuthInitial extends AuthState {
  const RemoteAuthInitial();
}

class RemoteAuthLoading extends AuthState {
  const RemoteAuthLoading();
}

class RemoteAuthFailed extends AuthState {
  const RemoteAuthFailed(Map<String, dynamic> error) : super(error: error);

  @override
  List<Object?> get props => [error];
}

class RemoteAuthLogin extends AuthState {
  const RemoteAuthLogin(AdminEntity admin) : super(admin: admin);

  @override
  List<Object?> get props => [admin];
}

class RemoteAuthRegister extends AuthState {
  const RemoteAuthRegister(AdminEntity admin) : super(admin: admin);

  @override
  List<Object?> get props => [admin];
}

class RemoteAuthSendOTP extends AuthState {
  const RemoteAuthSendOTP(String msg) : super(msg: msg);

  @override
  List<Object?> get props => [msg];
}

class RemotePasswordValidator extends AuthState {
  const RemotePasswordValidator(String passwordNotValid)
      : super(passwordNotValid: passwordNotValid);

  @override
  List<Object?> get props => [passwordNotValid];
}

class RemoteAuthVerifyOTP extends AuthState {
  const RemoteAuthVerifyOTP(Map<String, dynamic> data) : super(data: data);

  @override
  List<Object?> get props => [data];
}
