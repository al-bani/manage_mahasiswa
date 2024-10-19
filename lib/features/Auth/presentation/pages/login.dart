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
      return Container(
        margin: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: username,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                labelText: "Username",
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 10),
            PasswordField(passwordValue: password, text: "Password"),
            SizedBox(height: 20),
            isBtnLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      fixedSize:
                          Size.fromWidth(MediaQuery.of(context).size.width),
                    ),
                    onPressed: () {
                      if (username.text.isEmpty || password.text.isEmpty) {
                        _loginFailed(
                            context, state, "fill username and password");
                      } else {
                        BlocProvider.of<AuthBloc>(context).add(
                          LoginEvent(username.text, password.text),
                        );
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => GoRouter.of(context).goNamed('register'),
                child: Txt(
                    value: "Don't have an account? register here",
                    size: 14,
                    align: TextAlign.center),
              ),
            ),
          ],
        ),
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
