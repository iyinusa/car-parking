class UserModel {
  String? username;
  String email;
  String password;
  String? firstName;
  String? lastName;

  UserModel({
    this.username,
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
  });
}
