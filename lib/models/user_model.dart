enum UserRole { admin, guru, siswa, ortu }

enum UserType { normal, cadel, school, personal }

class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final UserType? type;
  final String? organizeId;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.type,
    this.organizeId,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.siswa,
      ),
      type: json['type'] != null
          ? UserType.values.firstWhere(
              (e) => e.name == json['type'],
              orElse: () => UserType.normal,
            )
          : null,
      organizeId: json['organize_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'type': type?.name,
      'organize_id': organizeId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    UserType? type,
    String? organizeId,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      type: type ?? this.type,
      organizeId: organizeId ?? this.organizeId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get roleDisplayName {
    switch (role) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.guru:
        return 'Guru';
      case UserRole.siswa:
        return 'Siswa';
      case UserRole.ortu:
        return 'Orang Tua';
    }
  }
}