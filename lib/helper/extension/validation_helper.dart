// ignore_for_file: unnecessary_this

extension Validate on String {
  bool isValidEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }

  bool isRequired() {
    return this.isNotEmpty;
  }

  bool lengthRange() {
    return this.length > 5 && this.length < 12;
  }
}
