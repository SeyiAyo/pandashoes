class UserModel {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final String? phoneNumber;
  final String? address;
  final List<String> favorites;
  final List<String> orders;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.phoneNumber,
    this.address,
    List<String>? favorites,
    List<String>? orders,
  })  : favorites = favorites ?? [],
        orders = orders ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'address': address,
      'favorites': favorites,
      'orders': orders,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      favorites: List<String>.from(map['favorites'] ?? []),
      orders: List<String>.from(map['orders'] ?? []),
    );
  }
}
