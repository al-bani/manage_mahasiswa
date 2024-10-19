String passwordValidator(String password) {
  String result = "";

  if (password.length < 9) {
    result = "${result}Password must be 9 characters or more\n";
  }

  if (!password.contains(RegExp(r'[^\w\s]'))) {
    result = "${result}The password must have at least one special character\n";
  }

  if (!password.contains(RegExp(r'\d'))) {
    result = "${result}The password must have at least one number\n";
  }

  return result;
}

bool nullDataChecking(email, password, confirmPassword, username) {
  if (email.isEmpty ||
      password.isEmpty ||
      username.isEmpty ||
      confirmPassword.isEmpty) {
    return true;
  }

  return false;
}

bool passwordCheck(password, confirmPassword) {
  if (password == confirmPassword) {
    return true;
  }
  return false;
}

bool emailCheck(String email) {
  if (email
      .contains(RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'))) {
    return true;
  }

  return false;
}
