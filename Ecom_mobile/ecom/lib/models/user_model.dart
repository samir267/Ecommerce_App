class UserModel {
  final int id;
  final String username;
  final String email;
  final String password;
  final String address;
  final String? phone;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.address,
    this.phone,  // Permettre que le numéro de téléphone soit null
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      password: json['password'],
    );
  }

  // Méthode toJson pour convertir l'objet UserModel en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'address': address,
      'phone': phone,
      'password': password,
    };
  }
}
