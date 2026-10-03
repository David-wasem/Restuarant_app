class User {
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? password;
  String? image;
  int? age;

  User({
    this.firstName,
    this.email,
    required this.username,
    required this.password,
    required this.lastName,
    this.image,
    this.age,
  });

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      username: jsonData['username'],
      password: jsonData['password'],
      email: jsonData['email'],
      firstName: jsonData['firstName'],
      lastName: jsonData['lastName'],
      image: jsonData['image'],
      age: jsonData['age'],
    );
  }
}
