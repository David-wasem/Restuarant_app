class UserRestModel {
  String userEmail;
  String password;
  String usercode;

  UserRestModel({
    required this.userEmail,
    required this.password,
    required this.usercode,
  });

  factory UserRestModel.fromJson(Map<String, dynamic> json) {
    return UserRestModel(
      userEmail: json['userEmail'],
      password: json['password'],
      usercode: json['usercode'],
    );
  }
}