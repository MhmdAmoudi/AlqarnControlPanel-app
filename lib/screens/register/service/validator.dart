extension ValidateSignup on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp = RegExp('[\u0600-\u065F-\u066A-\u06EF-\u06FA-\u06FF- ]')
        .allMatches(this);
    return nameRegExp.length == length;
  }

  bool get isValidUsername {
    final usernameRegExp = RegExp(r'[0-9a-zA-z]').allMatches(this);
    return usernameRegExp.length == length;
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r'[0-9]');
    return phoneRegExp.hasMatch(this) &&
        length == 9 &&
        [
          '70',
          '71',
          '73',
          '77',
        ].contains('7${this[1]}');
  }
}
