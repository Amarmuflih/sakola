// models/student_model.dart
class StudentModel {
  final int totalSiswa;

  StudentModel({required this.totalSiswa});

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(totalSiswa: json['total_siswa']);
  }
}
