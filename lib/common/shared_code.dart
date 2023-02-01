class SharedCode {
  String? emptyValidator(value) {
    return value.toString().trim().isEmpty ? 'Bidang tidak boleh kosong' : null;
  }

  String? emailValidator(value) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    return !emailValid ? 'Email tidak valid' : null;
  }

  String? passwordValidator(value) {
    return value.toString().length < 6 ? 'Kata sandi tidak boleh kurang dari 6 karakter' : null;
  }
}