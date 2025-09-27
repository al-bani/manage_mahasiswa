import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/bloc/auth_event.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/bloc/auth_state.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';
import 'package:manage_mahasiswa/injection_container.dart';
import 'package:pinput/pinput.dart';

bool isBtnLoading = false;

class VerificationScreen extends StatelessWidget {
  final String email;
  const VerificationScreen(this.email, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => containerInjection<AuthBloc>(),
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RemoteAuthVerifyOTP) {
              _dialogPopUpSuccess(context);
            } else if (state is RemoteAuthFailed) {
              _dialogPopUpFailed(
                context: context,
                message: state.error!["message"],
              );
              isBtnLoading = false;
            } else if (state is RemoteAuthSendOTP) {
              _dialogPopUpFailed(
                context: context,
                message: state.msg!,
              );
              startCountdown();
              isBtnLoading = false;
            } else if (state is RemoteAuthLoading) {
              isBtnLoading = true;
            }
          },
          child: _appbody(email, context),
        ),
      ),
    );
  }
}

final StreamController<int> streamController = StreamController<int>();

Stream<int> resendOTPCountdown() {
  return Stream<int>.periodic(const Duration(seconds: 1), (x) => 30 - x)
      .take(31);
}

void startCountdown() {
  streamController.addStream(resendOTPCountdown());
}

Widget _appbody(String email, context) {
  TextEditingController otpController = TextEditingController();
  startCountdown();

  return Container(
    margin: const EdgeInsets.all(30),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Txt(
            value: "Verification",
            size: 30,
            align: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Txt(
            value: "6 digit code was sent to your email $email",
            size: 16,
            align: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _pinput(otpController),
          const SizedBox(height: 70),
          isBtnLoading
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  child: Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          int otp = int.parse(otpController.text);
                          BlocProvider.of<AuthBloc>(context)
                              .add(VerifyOTPEvent(email, otp));
                        },
                        style: BtnStyle,
                        child: const Txt(
                          value: "Verify",
                          size: 16,
                          align: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: StreamBuilder<int>(
              stream: streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('...');
                } else if (snapshot.hasError) {
                  return const Text("An Error Request",
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center);
                } else if (snapshot.connectionState == ConnectionState.done ||
                    snapshot.data == 0) {
                  return InkWell(
                    onTap: () {
                      BlocProvider.of<AuthBloc>(context)
                          .add((ResendOTPEvent(email)));
                    },
                    child: const Text("Resend code to email",
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center),
                  );
                } else {
                  return Text("Resend code in ${snapshot.data}",
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center);
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}

_pinput(TextEditingController otpController) {
  return Pinput(
    length: 6,
    controller: otpController,
  );
}

void _dialogPopUpSuccess(context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Txt(
        value: "Information",
        size: 18,
        align: TextAlign.left,
      ),
      content: const Txt(
        value: "Verification Success, Login now",
        size: 14,
        align: TextAlign.left,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
            GoRouter.of(context).goNamed('login');
          },
          child: const Txt(
            value: "OK",
            size: 16,
            align: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

void _dialogPopUpFailed({required String message, required context}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Txt(
        value: "Information",
        size: 18,
        align: TextAlign.left,
      ),
      content: Txt(
        value: message,
        size: 14,
        align: TextAlign.left,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Txt(
            value: "OK",
            size: 16,
            align: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
