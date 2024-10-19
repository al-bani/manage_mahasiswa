import 'package:manage_mahasiswa/features/Auth/domain/entities/admin_entity.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent(this.username, this.password);

  List<Object?> get props => [
        username,
        password,
      ];
}

class RegisterEvent extends AuthEvent {
  final AdminEntity data;

  RegisterEvent(this.data);

  List<Object?> get props => [
        data,
      ];
}

class SendOTPEvent extends AuthEvent {
  final String email;

  SendOTPEvent(this.email);

  List<Object?> get props => [
        email,
      ];
}

class ResendOTPEvent extends AuthEvent {
  final String email;

  ResendOTPEvent(this.email);

  List<Object?> get props => [
        email,
      ];
}

class VerifyOTPEvent extends AuthEvent {
  final String email;
  final int otpInput;

  VerifyOTPEvent(this.email, this.otpInput);

  List<Object?> get props => [
        email,
        otpInput,
      ];
}

class PasswordValidatorEvent extends AuthEvent {
  final String password;

  PasswordValidatorEvent(this.password);

  List<Object?> get props => [
        password,
      ];
}
