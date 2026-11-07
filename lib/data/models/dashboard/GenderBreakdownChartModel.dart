
import 'package:sakola/data/models/dashboard/ParseHelper.dart';

/// Model reusable untuk response yang berbentuk:
/// {
///   "total": 0,
///   "gender_breakdown": [lakiLaki, perempuan, total]
/// }
///
/// Dipakai oleh 4 endpoint dashboard:
/// - student_register_charts
/// - student_graduated_charts
/// - student_active_charts
/// - get_teacher_charts
///
/// Catatan: gender_breakdown bisa berisi null (contoh: [null, null, null])
/// sehingga setiap elemen di-parse aman menjadi 0 jika null.
class GenderBreakdownChartModel {
  final int total;
  final int lakiLaki;
  final int perempuan;
  final int totalGender;

  GenderBreakdownChartModel({
    required this.total,
    required this.lakiLaki,
    required this.perempuan,
    required this.totalGender,
  });

  factory GenderBreakdownChartModel.fromJson(Map<String, dynamic> json) {
    final breakdown = json['gender_breakdown'] as List<dynamic>?;

    return GenderBreakdownChartModel(
      total: ParseHelper.toInt(json['total']),
      lakiLaki: breakdown != null && breakdown.isNotEmpty
          ? ParseHelper.toInt(breakdown[0])
          : 0,
      perempuan: breakdown != null && breakdown.length > 1
          ? ParseHelper.toInt(breakdown[1])
          : 0,
      totalGender: breakdown != null && breakdown.length > 2
          ? ParseHelper.toInt(breakdown[2])
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'gender_breakdown': [lakiLaki, perempuan, totalGender],
    };
  }

  /// Factory kosong, berguna sebagai default state sebelum data API datang.
  factory GenderBreakdownChartModel.empty() {
    return GenderBreakdownChartModel(
      total: 0,
      lakiLaki: 0,
      perempuan: 0,
      totalGender: 0,
    );
  }
}