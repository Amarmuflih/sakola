/// Model untuk satu item response GET /v1/school_years.
///
/// Contoh response asli:
/// ```json
/// {
///   "id": 13,
///   "name": "2027/2028",
///   "year": "2027",
///   "is_active": false,
///   "created_at": "...",
///   "updated_at": "...",
///   "deleted_at": null
/// }
/// ```
/// `name` dipakai sebagai label ("2027/2028") karena itu yang biasanya
/// ditampilkan ke user, `year` cuma angka tahun awalnya doang ("2027").
class SchoolYear {
  final String id;
  final String label;
  final bool isActive;

  SchoolYear({required this.id, required this.label, required this.isActive});

  factory SchoolYear.fromJson(Map<String, dynamic> json) {
    return SchoolYear(
      id: (json['id'] ?? '').toString(),
      label: (json['name'] ?? json['year'] ?? '').toString(),
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }
}
