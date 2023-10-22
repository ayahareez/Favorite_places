class UserModel {
  String email, password, name;
  UserModel({required this.password, required this.email, required this.name});

  Map<String, dynamic> toMap() =>
      {'email': email, 'password': password, 'name': name};

  factory UserModel.fromMap(Map<String, dynamic> map) =>
      UserModel(email: map['email'], password: map['password'], name: '');
}