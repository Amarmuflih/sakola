import 'package:sakola/data/models/dashboard/ParseHelper.dart';


/// Model untuk response endpoint student_list_register_per_year.
///
/// Bentuk response:
/// {
///   "tahun": ["2016/2017", "2017/2018", ...],
///   "perempuan": [0, 0, ...],
///   "lakilaki": [0, 0, ...]
/// }
class StudentListRegisterPerYearModel {
  final List<String> tahun;
  final List<int> perempuan;
  final List<int> lakilaki;

  StudentListRegisterPerYearModel({
    required this.tahun,
    required this.perempuan,
    required this.lakilaki,
  });

  factory StudentListRegisterPerYearModel.fromJson(Map<String, dynamic> json) {
    return StudentListRegisterPerYearModel(
      tahun: ParseHelper.toStringList(json['tahun']),
      perempuan: ParseHelper.toIntList(json['perempuan']),
      lakilaki: ParseHelper.toIntList(json['lakilaki']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tahun': tahun,
      'perempuan': perempuan,
      'lakilaki': lakilaki,
    };
  }

  factory StudentListRegisterPerYearModel.empty() {
    return StudentListRegisterPerYearModel(
      tahun: [],
      perempuan: [],
      lakilaki: [],
    );
  }
}