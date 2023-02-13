class SignupUser {
  String name;
  String username;
  String email;
  String password;
  String privateCode;

  SignupUser({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.privateCode,
  });

  static Map<String, String> toJson(SignupUser user) {
    return {
      'name': user.name,
      'username': user.username,
      'email': user.email,
      'password': user.password,
      'privateCode': user.privateCode,
    };
  }
}
