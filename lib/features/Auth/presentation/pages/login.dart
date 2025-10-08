import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_mahasiswa/core/resources/data_local.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/bloc/auth_event.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/bloc/auth_state.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';
import 'package:manage_mahasiswa/injection_container.dart';

TextEditingController username = TextEditingController();
TextEditingController password = TextEditingController();
bool isBtnLoading = false;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocProvider(
        create: (context) => containerInjection<AuthBloc>(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RemoteAuthLogin) {
              _loginSuccess(context, state.admin);
              isBtnLoading = false;
            } else if (state is RemoteAuthFailed) {
              _loginFailed(context, state, state.error!["msg"]);
              isBtnLoading = false;
            } else if (state is RemoteAuthLoading) {
              isBtnLoading = true;
            }
          },
          child: _appBody(context),
        ),
      ),
    );
  }
}

_appBody(context) {
  return BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      return Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello",
                    style: AppTextStyles.openSansBold(
                        fontSize: 28, color: AppColors.secondary),
                  ),
                  Text(
                    "Welcome back",
                    style: AppTextStyles.openSansBold(
                        fontSize: 28, color: AppColors.white),
                  ),
                  Text(
                    "Glad to see you again !",
                    style: AppTextStyles.openSansBold(
                        fontSize: 28, color: AppColors.white),
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
                  AppTextField(
                    controller: username,
                    hintText: "Insert your Username",
                  ),
                  const SizedBox(height: 20),
                  AppPasswordTextField(
                    controller: password,
                    hintText: "Insert your Password",
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => GoRouter.of(context).goNamed('register'),
                      child: const Text(
                        "Forgot Password",
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  isBtnLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            AppButton(
                              text: "Login",
                              onPressed: () {
                                if (username.text.isEmpty ||
                                    password.text.isEmpty) {
                                  _loginFailed(context, state,
                                      "fill username and password");
                                } else {
                                  BlocProvider.of<AuthBloc>(context).add(
                                    LoginEvent(username.text, password.text),
                                  );
                                }
                              },
                              backgroundColor: AppColors.primary,
                            ),
                            const SizedBox(height: 10),
                            AppButton(
                              text: "Register",
                              onPressed: () =>
                                  GoRouter.of(context).goNamed('register'),
                              backgroundColor: AppColors.secondary,
                            ),
                          ],
                        ),
                  const SizedBox(height: 20),
                  Text(
                    "Or Continue With",
                    style: AppTextStyles.openSansItalic(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

_loginSuccess(context, data) async {
  await setLoginStatus(data);

  GoRouter.of(context).goNamed('home');
}

_loginFailed(context, state, String value) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Txt(
        value: "Information",
        size: 18,
        align: TextAlign.left,
      ),
      content: Txt(
        value: value,
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
