class RegisterParamsModel {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String? confirmPassword;

  RegisterParamsModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    this.confirmPassword,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'phone': phone,
    'email': email,
    'password': password,
  };
}
