import 'package:flutter/material.dart';

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

