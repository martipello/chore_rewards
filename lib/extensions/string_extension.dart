extension StringExtension on String? {
  bool isValidPassword() {
    if (this != null && this!.isNotEmpty) {
      final password = this!;
      var hasUppercase = password.contains(RegExp(r'[A-Z]'));
      var hasDigits = password.contains(RegExp(r'[0-9]'));
      var hasLowercase = password.contains(RegExp(r'[a-z]'));
      var hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      return password.length > 7 &&
          [hasUppercase, hasLowercase, hasSpecialCharacters, hasDigits].where((e) => e == true).length > 2;
    } else {
      return false;
    }
  }

  String capitalize() {
    if (this != null && this!.isNotEmpty) {
      return '${this![0].toUpperCase()}${this!.substring(1)}';
    } else {
      return '';
    }
  }

  String removeLastCharacter() {
    if (this != null && this!.isNotEmpty) {
      return this!.substring(0, this!.length - 1);
    } else {
      return '';
    }
  }
}
