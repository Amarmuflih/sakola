import 'package:sakola/data/models/dashboard/ParseHelper.dart';

/// Model untuk chart SPP di dalam financial_overview.
///
/// Bentuk response:
/// {
///   "categories": ["Jan", "Feb", ...],
///   "series": [0, 0, ...]
/// }
class SppChartModel {
  final List<String> categories;
  final List<double> series;

  SppChartModel({required this.categories, required this.series});

  factory SppChartModel.fromJson(Map<String, dynamic> json) {
    return SppChartModel(
      categories: ParseHelper.toStringList(json['categories']),
      series: ParseHelper.toDoubleList(json['series']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'categories': categories, 'series': series};
  }

  factory SppChartModel.empty() {
    return SppChartModel(categories: [], series: []);
  }
}

/// Model untuk bagian "data" di dalam response financial_overview.
///
/// Bentuk response:
/// {
///   "total_pendapatan": 0,
///   "total_pengeluaran": 0,
///   "spp_chart": { ... SppChartModel ... }
/// }
class FinancialOverviewDataModel {
  final double totalPendapatan;
  final double totalPengeluaran;
  final SppChartModel sppChart;

  FinancialOverviewDataModel({
    required this.totalPendapatan,
    required this.totalPengeluaran,
    required this.sppChart,
  });

  factory FinancialOverviewDataModel.fromJson(Map<String, dynamic> json) {
    return FinancialOverviewDataModel(
      totalPendapatan: ParseHelper.toDouble(json['total_pendapatan']),
      totalPengeluaran: ParseHelper.toDouble(json['total_pengeluaran']),
      sppChart: json['spp_chart'] != null
          ? SppChartModel.fromJson(json['spp_chart'] as Map<String, dynamic>)
          : SppChartModel.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_pendapatan': totalPendapatan,
      'total_pengeluaran': totalPengeluaran,
      'spp_chart': sppChart.toJson(),
    };
  }

  factory FinancialOverviewDataModel.empty() {
    return FinancialOverviewDataModel(
      totalPendapatan: 0,
      totalPengeluaran: 0,
      sppChart: SppChartModel.empty(),
    );
  }
}

/// Model untuk response endpoint financial_overview.
///
/// Bentuk response:
/// {
///   "status": "success",
///   "data": { ... FinancialOverviewDataModel ... }
/// }
class FinancialOverviewModel {
  final String status;
  final FinancialOverviewDataModel data;

  FinancialOverviewModel({required this.status, required this.data});

  factory FinancialOverviewModel.fromJson(Map<String, dynamic> json) {
    return FinancialOverviewModel(
      status: ParseHelper.toStringSafe(json['status']),
      data: json['data'] != null
          ? FinancialOverviewDataModel.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : FinancialOverviewDataModel.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'data': data.toJson()};
  }

  factory FinancialOverviewModel.empty() {
    return FinancialOverviewModel(
      status: '',
      data: FinancialOverviewDataModel.empty(),
    );
  }
}
