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

class VerificationScreen extends StatefulWidget {
  final String email;
  const VerificationScreen(this.email, {super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool isBtnLoading = false;
  late StreamController<int> streamController;
  Timer? countdownTimer;
  int countdownValue = 30;
  bool _isProcessing = false; // Prevent multiple rapid clicks

  @override
  void initState() {
    super.initState();
    streamController = StreamController<int>.broadcast();
    startCountdown();
    // Reset any previous state by creating a fresh bloc instance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Force a rebuild to ensure clean state
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Handle hot reload issues
    if (mounted) {
      // Ensure state is consistent after hot reload
      setState(() {
        isBtnLoading = false;
        _isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    streamController.close();
    countdownTimer?.cancel();
    super.dispose();
  }

  void startCountdown() {
    countdownValue = 30;
    streamController.add(countdownValue);

    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownValue > 0) {
        countdownValue--;
        streamController.add(countdownValue);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => containerInjection<AuthBloc>(),
      key: ValueKey('verification_bloc_${widget.email}'),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Builder(
          builder: (context) {
            try {
              return BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  try {
                    print(
                        "VerificationScreen received state: ${state.runtimeType}");

                    if (state is RemoteAuthLoading) {
                      if (mounted) {
                        setState(() {
                          isBtnLoading = true;
                        });
                      }
                    } else if (state is RemoteAuthVerifyOTP) {
                      _dialogPopUpSuccess(context);
                    } else if (state is RemoteAuthSendOTP) {
                      final message = state.msg ?? "OTP berhasil dikirim";
                      _dialogPopUpFailed(
                        context: context,
                        message: message,
                      );
                      startCountdown();
                      if (mounted) {
                        setState(() {
                          isBtnLoading = false;
                        });
                      }
                    } else if (state is RemoteAuthFailed) {
                      final errorMessage = state.error?["message"] ??
                          "Terjadi kesalahan yang tidak diketahui";
                      _dialogPopUpFailed(
                        context: context,
                        message: errorMessage,
                      );
                      if (mounted) {
                        setState(() {
                          isBtnLoading = false;
                        });
                      }
                    } else if (state is RemotePasswordValidator) {
                      // Handle password validation error (should not happen in verification screen)
                      final message =
                          state.passwordNotValid ?? "Password tidak valid";
                      _dialogPopUpFailed(
                        context: context,
                        message: message,
                      );
                      if (mounted) {
                        setState(() {
                          isBtnLoading = false;
                        });
                      }
                    } else if (state is RemoteAuthRegister) {
                      // Handle successful registration (should not happen in verification screen)
                      print(
                          "Unexpected state: RemoteAuthRegister in verification screen");
                      if (mounted) {
                        setState(() {
                          isBtnLoading = false;
                        });
                      }
                    } else if (state is RemoteAuthLogin) {
                      // Handle successful login (should not happen in verification screen)
                      print(
                          "Unexpected state: RemoteAuthLogin in verification screen");
                      if (mounted) {
                        setState(() {
                          isBtnLoading = false;
                        });
                      }
                    } else {
                      // Handle any other unexpected states
                      print("Unexpected state: ${state.runtimeType}");
                      if (mounted) {
                        setState(() {
                          isBtnLoading = false;
                        });
                      }
                    }
                  } catch (e) {
                    print("Error in BlocListener: $e");
                    if (mounted) {
                      setState(() {
                        isBtnLoading = false;
                      });
                    }
                  }
                },
                builder: (context, state) {
                  return _appbody(widget.email, context, isBtnLoading,
                      streamController, _isProcessing, () {
                    setState(() {
                      _isProcessing = !_isProcessing;
                    });
                  });
                },
              );
            } catch (e) {
              print("Error in BlocConsumer builder: $e");
              return _buildErrorWidget(context, e.toString());
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              "Something Went Error",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Error: $error",
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Restart the widget by calling setState
                setState(() {});
              },
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _appbody(
    String email,
    BuildContext context,
    bool isBtnLoading,
    StreamController<int> streamController,
    bool isProcessing,
    Function() onProcessingChange) {
  TextEditingController otpController = TextEditingController();

  return Column(
    children: [
      Expanded(
        flex: 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "OTP VERIFICATION",
                style: AppTextStyles.openSansBold(
                    fontSize: 28, color: AppColors.secondary),
              ),
              Text(
                textAlign: TextAlign.center,
                "6 digit code was sent to your email $email",
                style: AppTextStyles.openSansItalic(
                    fontSize: 14, color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30),
              _pinput(otpController),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: StreamBuilder<int>(
                  stream: streamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        '...',
                        style: AppTextStyles.openSansItalic(
                            fontSize: 12, color: AppColors.primary),
                      );
                    } else if (snapshot.hasError) {
                      return Text("An Error Request",
                          style: AppTextStyles.openSansItalic(
                              fontSize: 12, color: AppColors.primary));
                    } else if (snapshot.connectionState ==
                            ConnectionState.done ||
                        snapshot.data == 0) {
                      return InkWell(
                        onTap: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add((ResendOTPEvent(email)));
                        },
                        child: Text("Resend code to email",
                            style: AppTextStyles.openSansItalic(
                                fontSize: 12, color: AppColors.primary)),
                      );
                    } else {
                      return Text("Resend code in ${snapshot.data}",
                          style: AppTextStyles.openSansItalic(
                              fontSize: 12, color: AppColors.primary));
                    }
                  },
                ),
              ),
              const SizedBox(height: 50),
              isBtnLoading
                  ? const CircularProgressIndicator()
                  : AppButton(
                      text: "Submit",
                      onPressed: () {
                        int otp = int.parse(otpController.text);
                        BlocProvider.of<AuthBloc>(context)
                            .add(VerifyOTPEvent(email, otp));
                      },
                      backgroundColor: AppColors.secondary,
                    ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    ],
  );

  // return Container(
  //   margin: const EdgeInsets.all(30),
  //   child: Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         const Txt(
  //           value: "Verification",
  //           size: 30,
  //           align: TextAlign.center,
  //         ),
  //         const SizedBox(height: 10),
  //         Txt(
  //           value: "6 digit code was sent to your email $email",
  //           size: 16,
  //           align: TextAlign.center,
  //         ),
  //         const SizedBox(height: 30),
  //         _pinput(otpController),
  //         const SizedBox(height: 70),
  //         isBtnLoading
  //             ? const CircularProgressIndicator()
  //             : SizedBox(
  //                 width: double.infinity,
  //                 child: Builder(
  //                   builder: (context) {
  //                     return ElevatedButton(
  //                       onPressed: isProcessing
  //                           ? null
  //                           : () async {
  //                               if (isProcessing) return;

  //                               try {
  //                                 onProcessingChange();

  //                                 if (otpController.text.length == 6) {
  //                                   int otp = int.parse(otpController.text);
  //                                   BlocProvider.of<AuthBloc>(context)
  //                                       .add(VerifyOTPEvent(email, otp));
  //                                 } else {
  //                                   _dialogPopUpFailed(
  //                                     context: context,
  //                                     message: "Silakan masukkan 6 digit OTP.",
  //                                   );
  //                                 }
  //                               } catch (e) {
  //                                 print("Error in verify button: $e");
  //                                 _dialogPopUpFailed(
  //                                   context: context,
  //                                   message:
  //                                       "Format OTP tidak valid. Silakan masukkan 6 digit angka.",
  //                                 );
  //                               } finally {
  //                                 onProcessingChange();
  //                               }
  //                             },
  //                       style: BtnStyle,
  //                       child: const Txt(
  //                         value: "Verify",
  //                         size: 16,
  //                         align: TextAlign.center,
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //         const SizedBox(height: 10),
  //         Align(
  //           alignment: Alignment.centerLeft,
  //           child: StreamBuilder<int>(
  //             stream: streamController.stream,
  //             builder: (context, snapshot) {
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return const Text('...');
  //               } else if (snapshot.hasError) {
  //                 return const Text("An Error Request",
  //                     style: TextStyle(fontSize: 12),
  //                     textAlign: TextAlign.center);
  //               } else if (snapshot.data == 0) {
  //                 return InkWell(
  //                   onTap: () async {
  //                     try {
  //                       BlocProvider.of<AuthBloc>(context)
  //                           .add((ResendOTPEvent(email)));
  //                     } catch (e) {
  //                       print("Error in resend OTP: $e");
  //                     }
  //                   },
  //                   child: const Text("Resend code to email",
  //                       style: TextStyle(fontSize: 12),
  //                       textAlign: TextAlign.center),
  //                 );
  //               } else {
  //                 return Text("Resend code in ${snapshot.data}",
  //                     style: const TextStyle(fontSize: 12),
  //                     textAlign: TextAlign.center);
  //               }
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  // );
}

_pinput(TextEditingController otpController) {
  return Pinput(
    length: 6,
    controller: otpController,
    keyboardType: TextInputType.number,
  );
}

void _dialogPopUpSuccess(BuildContext context) {
  if (!context.mounted) return;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      title: const Txt(
        value: "Informasi",
        size: 18,
        align: TextAlign.left,
      ),
      content: const Txt(
        value: "Verifikasi berhasil, silakan login sekarang",
        size: 14,
        align: TextAlign.left,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext, 'OK');
            if (context.mounted) {
              GoRouter.of(context).goNamed('login');
            }
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

void _dialogPopUpFailed(
    {required String message, required BuildContext context}) {
  if (!context.mounted) return;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => AlertDialog(
      title: const Txt(
        value: "Informasi",
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
          onPressed: () {
            if (dialogContext.mounted) {
              Navigator.pop(dialogContext, 'OK');
            }
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
