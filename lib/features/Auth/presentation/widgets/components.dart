import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle openSansRegular({
    double fontSize = 14,
    Color color = Colors.black,
  }) =>
      GoogleFonts.openSans(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w400,
      );

  // Open Sans Bold
  static TextStyle openSansBold({
    double fontSize = 14,
    Color color = Colors.black,
  }) =>
      GoogleFonts.openSans(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w700,
      );

  // Open Sans Italic
  static TextStyle openSansItalic({
    double fontSize = 14,
    Color color = Colors.black,
  }) =>
      GoogleFonts.openSans(
        fontSize: fontSize,
        color: color,
        fontStyle: FontStyle.italic,
      );

  static TextStyle openSansBoldItalic({
    double fontSize = 14,
    Color color = Colors.black,
  }) =>
      GoogleFonts.openSans(
        fontSize: fontSize,
        color: color,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w700,
      );
}

class AppColors {
  static const Color primary = Color(0xFF243642);
  static const Color secondary = Color(0xFFFD8B51);
  static const Color white = Color(0xffffffff);
  static const Color grey = Color(0xFFEFEFEF);
}

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey, // misal warna #EFEFEF
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.openSansItalic(fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

class AppPasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const AppPasswordTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<AppPasswordTextField> createState() => _AppPasswordTextFieldState();
}

class _AppPasswordTextFieldState extends State<AppPasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.openSansItalic(fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderRadius = 20, // 🔹 default radius
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // biar tombol full width
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? AppColors.white,
          elevation: 0, // tanpa shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding,
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.openSansBold(
              fontSize: 16,
              color: textColor ?? AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

//
//
//
//
//
// :warn INI BELUM DI UPDATE LAGI

class PasswordField extends StatefulWidget {
  final TextEditingController passwordValue;
  final String text;

  const PasswordField(
      {super.key, required this.passwordValue, required this.text});

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
