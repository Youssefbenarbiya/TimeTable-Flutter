class TeacherModel {
  final int id;
  late final String name;

  TeacherModel({required this.id, required this.name});

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'],
      name: json['name'],
    );
  }
   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
