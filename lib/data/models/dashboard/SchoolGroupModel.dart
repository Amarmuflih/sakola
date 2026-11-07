class SchoolGroup {
  final String id;
  final String name;
 
  SchoolGroup({required this.id, required this.name});
 
  factory SchoolGroup.fromJson(Map<String, dynamic> json) {
    return SchoolGroup(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ??
              json['group_name'] ??
              json['company_name'] ??
              json['label'] ??
              '')
          .toString(),
    );
  }
}
 