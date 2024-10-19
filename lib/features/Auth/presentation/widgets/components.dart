import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController passwordValue;
  final String text;

  const PasswordField({super.key, required this.passwordValue, required this.text});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: !_isPasswordVisible,
      controller: widget.passwordValue,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        labelText: widget.text,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontStyle: FontStyle.italic,
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }
}

class NormalFiled extends StatelessWidget {
  final String text;
  final TextEditingController controller;

  const NormalFiled({super.key, required this.text, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        labelText: text,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class Txt extends StatelessWidget {
  final String value;
  final double? size;
  final TextAlign align;

  const Txt(
      {super.key,
      required this.value,
      required this.size,
      required this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        color: Colors.black,
        fontSize: size,
      ),
      textAlign: align,
    );
  }
}

final ButtonStyle BtnStyle = ElevatedButton.styleFrom(
  textStyle: const TextStyle(fontSize: 20),
  backgroundColor: Colors.blue[300],
);
