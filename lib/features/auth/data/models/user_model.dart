class UserModel {
  final String? id;
  final String? email;
  final String? name;
  final String? profilePicture;
  final bool isAdmin;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.profilePicture,
    this.isAdmin = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      profilePicture: map['profile_picture'],
      isAdmin: map['is_admin'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profile_picture': profilePicture,
      'is_admin': isAdmin,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profilePicture,
    bool? isAdmin,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
