class UserModel {
  String email, password;
  UserModel({required this.password, required this.email});

  // Map<String, dynamic> toMap() =>
  //     {'email': email, 'password': password};
  //
  // factory UserModel.fromMap(Map<String, dynamic> map) =>
  //     UserModel(email: map['email'], password: map['password']);
}