import 'package:sakola/data/models/dashboard/ParseHelper.dart';

/// Model generik untuk endpoint operational_cost_pie_chart.
///
/// PENTING: pada saat model ini dibuat, response API masih berupa
/// array kosong ("[]") karena belum ada data operational cost.
/// Struktur item di bawah ini adalah ASUMSI generik {label, value}
/// yang umum dipakai untuk pie chart. Sesuaikan field-nya begitu
/// contoh data asli (item non-kosong) sudah didapat dari backend.
class OperationalCostItemModel {
  final String label;
  final double value;

  OperationalCostItemModel({
    required this.label,
    required this.value,
  });

  factory OperationalCostItemModel.fromJson(Map<String, dynamic> json) {
    // Fallback antar kemungkinan nama field umum (name/label, value/total/amount)
    final dynamic rawLabel = json['label'] ?? json['name'] ?? json['category'];
    final dynamic rawValue = json['value'] ?? json['total'] ?? json['amount'];

    return OperationalCostItemModel(
      label: ParseHelper.toStringSafe(rawLabel),
      value: ParseHelper.toDouble(rawValue),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
    };
  }
}

/// Wrapper list, supaya pemanggilan di repository konsisten dengan
/// model lain (selalu punya factory fromJson/empty).
class OperationalCostPieChartModel {
  final List<OperationalCostItemModel> items;

  OperationalCostPieChartModel({required this.items});

  factory OperationalCostPieChartModel.fromJson(dynamic json) {
    if (json == null || json is! List) {
      return OperationalCostPieChartModel(items: []);
    }
    return OperationalCostPieChartModel(
      items: json
          .map((e) => OperationalCostItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  List<dynamic> toJson() => items.map((e) => e.toJson()).toList();

  factory OperationalCostPieChartModel.empty() {
    return OperationalCostPieChartModel(items: []);
  }
}