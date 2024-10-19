import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_mahasiswa/core/validator/validator.dart';
import 'package:manage_mahasiswa/features/Auth/domain/entities/admin_entity.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/bloc/auth_event.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/bloc/auth_state.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';
import 'package:manage_mahasiswa/injection_container.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => containerInjection<AuthBloc>(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RemoteAuthRegister) {
              BlocProvider.of<AuthBloc>(context)
                  .add(SendOTPEvent(state.admin!.email!));
              _registerSuccess(context, state);
            } else if (state is RemoteAuthFailed ||
                state is RemotePasswordValidator) {
              String message = state is RemoteAuthFailed
                  ? state.error!["msg"]
                  : (state as RemotePasswordValidator).passwordNotValid!;
              _dialogPopUp(message, context);
            }
          },
          child: _appBody(context),
        ),
      ),
    );
  }

  Widget _appBody(BuildContext context) {
    final emailController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Register",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                NormalFiled(text: "Email", controller: emailController),
                SizedBox(height: 10),
                NormalFiled(text: "Username", controller: usernameController),
                SizedBox(height: 10),
                PasswordField(
                    passwordValue: passwordController, text: "Password"),
                SizedBox(height: 10),
                PasswordField(
                    passwordValue: confirmPasswordController,
                    text: "Confirm Password"),
                SizedBox(height: 10),
                _alignPasswordRequirement(),
                SizedBox(height: 30),
                state is RemoteAuthLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () => _onRegisterPressed(
                            context,
                            emailController.text,
                            usernameController.text,
                            passwordController.text,
                            confirmPasswordController.text),
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: BtnStyle,
                      ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () => GoRouter.of(context).goNamed('login'),
                    child: Text(
                      "already have an account, Login now",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _onRegisterPressed(BuildContext context, String email, String username,
      String password, String confirmPassword) {
    if (nullDataChecking(email, username, password, confirmPassword)) {
      _dialogPopUp("Fill all of data", context);
      return;
    }

    if (!emailCheck(email)) {
      _dialogPopUp("Wrong Format Email", context);
      return;
    }

    if (!passwordCheck(password, confirmPassword)) {
      _dialogPopUp("Confirm password must be the same", context);
      return;
    }

    final adminData = AdminEntity(
      email: email,
      username: username,
      password: password,
      token: "",
    );
    BlocProvider.of<AuthBloc>(context).add(RegisterEvent(adminData));
  }

  void _registerSuccess(BuildContext context, AuthState state) {
    GoRouter.of(context).goNamed('verification',
        extra: (state as RemoteAuthRegister).admin!.email!);
  }

  Widget _alignPasswordRequirement() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Password must be 8 characters or more",
            style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.black54),
          ),
          Text(
            "The password must have at least one character",
            style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.black54),
          ),
          Text(
            "The password must have numbers",
            style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.black54),
          ),
        ],
      ),
    );
  }

  void _dialogPopUp(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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
}
