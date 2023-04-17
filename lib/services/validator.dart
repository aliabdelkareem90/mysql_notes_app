class Validator {
  static validateInput(String? val, int max, int min) {
    if (val.toString().isEmpty) {
      return "This field can't be empty";
    } else if (val!.length > max) {
      return "Too large field input";
    } else if (val.length < min) {
      return "Too small field input";
    }
  }

  static validateEmail(String? email) {
    if (email.toString().isEmpty) {
      return "This field can't be empty";
    }
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email.toString());
    if (!emailValid) {
      return "Not a valid email format";
    }
  }
}
