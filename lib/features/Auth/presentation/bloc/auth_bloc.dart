import 'package:bloc/bloc.dart';
import 'package:manage_mahasiswa/core/resources/data_state.dart';
import 'package:manage_mahasiswa/core/validator/validator.dart';
import 'package:manage_mahasiswa/features/Auth/domain/usecases/login_usecase.dart';
import 'package:manage_mahasiswa/features/Auth/domain/usecases/register_usecase.dart';
import 'package:manage_mahasiswa/features/Auth/domain/usecases/otp_usecase.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/bloc/auth_event.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUsecase _registerUsecase;
  final OtpUsecase _otpUseCase;

  AuthBloc(this._loginUseCase, this._registerUsecase, this._otpUseCase)
      : super(const RemoteAuthInitial()) {
    on<LoginEvent>(onAdminLogin);
    on<RegisterEvent>(onAdminRegister);
    on<SendOTPEvent>(onSendOTP);
    on<ResendOTPEvent>(onResendOTP);
    on<VerifyOTPEvent>(onVerifyOTP);
  }

  void onAdminLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const RemoteAuthLoading());

    final dataState =
        await _loginUseCase.executeLogin(event.username, event.password);

    if (dataState is DataSuccess && dataState.data!.props.isNotEmpty) {
      emit(RemoteAuthLogin(dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteAuthFailed(dataState.error!));
    }
  }

  void onAdminRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(const RemoteAuthLoading());
    String pswdValidator = passwordValidator(event.data.password!);

    if (pswdValidator.isNotEmpty) {
      emit(RemotePasswordValidator(pswdValidator));
    } else {
      final dataState = await _registerUsecase.executeRegister(event.data);

      if (dataState is DataSuccess && dataState.data!.props.isNotEmpty) {
        emit(RemoteAuthRegister(dataState.data!));
      }

      if (dataState is DataFailed) {
        emit(RemoteAuthFailed(dataState.error!));
      }
    }
  }

  void onSendOTP(SendOTPEvent event, Emitter<AuthState> emit) async {
    emit(const RemoteAuthLoading());
    final dataState = await _otpUseCase.sendOtpExecute(event.email);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(RemoteAuthSendOTP(dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(RemoteAuthFailed(dataState.error!));
    }
  }

  void onResendOTP(ResendOTPEvent event, Emitter<AuthState> emit) async {
    emit(const RemoteAuthLoading());
    try {
      final dataStateResend = await _otpUseCase.resendOtpExecute(event.email);

      if (dataStateResend is DataSuccess && dataStateResend.data != null) {
        final Map<String, dynamic> data = dataStateResend.data!;
        final String message =
            (data["msg"] ?? "OTP berhasil dikirim").toString();
        emit(RemoteAuthSendOTP(message));
        return;
      }

      if (dataStateResend is DataFailed) {
        emit(RemoteAuthFailed(dataStateResend.error!));
        return;
      }

      // Fallback bila tidak ada state yang ter-cover di atas
      emit(const RemoteAuthFailed({"msg": "Resend OTP tidak berhasil"}));
    } catch (e) {
      emit(
          const RemoteAuthFailed({"msg": "Terjadi kesalahan saat resend OTP"}));
    }
  }

  void onVerifyOTP(VerifyOTPEvent event, Emitter<AuthState> emit) async {
    emit(const RemoteAuthLoading());
    final dataState =
        await _otpUseCase.verifyOTPExecute(event.email, event.otpInput);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(RemoteAuthVerifyOTP(dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(RemoteAuthFailed(dataState.error!));
    }
  }
}
