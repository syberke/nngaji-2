class OrganizeModel {
  final String id;
  final String name;
  final String? description;
  final String guruId;
  final DateTime createdAt;

  OrganizeModel({
    required this.id,
    required this.name,
    this.description,
    required this.guruId,
    required this.createdAt,
  });

  factory OrganizeModel.fromJson(Map<String, dynamic> json) {
    return OrganizeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      guruId: json['guru_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'guru_id': guruId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}