import 'package:shared_preferences/shared_preferences.dart';

class SharedCode {
  String? emptyValidator(value) {
    return value.toString().trim().isEmpty ? 'Bidang tidak boleh kosong' : null;
  }

  String? emailValidator(value) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    return !emailValid ? 'Email tidak valid' : null;
  }

  String? passwordValidator(value) {
    return value.toString().length < 6
        ? 'Kata sandi tidak boleh kurang dari 6 karakter'
        : null;
  }

  Future<bool> setToken(String token, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(token, value);
  }

  Future<bool> getToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(token) ?? false;
  }
}
