/// Helper untuk parsing nilai numerik dari API Sakola.
///
/// Beberapa field di response API dikirim tidak konsisten:
/// kadang sebagai String ("900000.00000"), kadang int (0), kadang null.
/// Helper ini menyeragamkan semua kemungkinan tersebut menjadi num yang aman.
class ParseHelper {
  ParseHelper._();

  /// Parse dynamic value menjadi double, default 0 jika null/invalid.
  static double toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  /// Parse dynamic value menjadi int, default 0 jika null/invalid.
  static int toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? (double.tryParse(value)?.toInt() ?? 0);
    return 0;
  }

  /// Parse dynamic value menjadi String, default '' jika null.
  static String toStringSafe(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  /// Parse List<dynamic> menjadi List<double>, tiap elemen null dianggap 0.
  static List<double> toDoubleList(dynamic value) {
    if (value == null || value is! List) return [];
    return value.map((e) => toDouble(e)).toList();
  }

  /// Parse List<dynamic> menjadi List<int>, tiap elemen null dianggap 0.
  static List<int> toIntList(dynamic value) {
    if (value == null || value is! List) return [];
    return value.map((e) => toInt(e)).toList();
  }

  /// Parse List<dynamic> menjadi List<String>, tiap elemen null dianggap ''.
  static List<String> toStringList(dynamic value) {
    if (value == null || value is! List) return [];
    return value.map((e) => toStringSafe(e)).toList();
  }
}