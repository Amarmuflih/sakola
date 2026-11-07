import 'package:sakola/data/models/dashboard/ParseHelper.dart';


/// Model untuk satu periode (monthly atau non_monthly) di dalam
/// response realization_vs_billing_data.
///
/// Bentuk response per periode:
/// {
///   "months": ["Januari", "Februari", ...],
///   "student_billings": ["900000.00000", 0, ...],
///   "student_payment": ["900000.00000", 0, ...]
/// }
///
/// Catatan: student_billings & student_payment kadang berupa String
/// angka desimal ("900000.00000") dan kadang int (0), sehingga
/// di-parse aman menjadi double.
class BillingPeriodModel {
  final List<String> months;
  final List<double> studentBillings;
  final List<double> studentPayment;

  BillingPeriodModel({
    required this.months,
    required this.studentBillings,
    required this.studentPayment,
  });

  factory BillingPeriodModel.fromJson(Map<String, dynamic> json) {
    return BillingPeriodModel(
      months: ParseHelper.toStringList(json['months']),
      studentBillings: ParseHelper.toDoubleList(json['student_billings']),
      studentPayment: ParseHelper.toDoubleList(json['student_payment']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'months': months,
      'student_billings': studentBillings,
      'student_payment': studentPayment,
    };
  }

  factory BillingPeriodModel.empty() {
    return BillingPeriodModel(
      months: [],
      studentBillings: [],
      studentPayment: [],
    );
  }
}

/// Model untuk response endpoint realization_vs_billing_data.
///
/// Bentuk response:
/// {
///   "monthly": { ... BillingPeriodModel ... },
///   "non_monthly": { ... BillingPeriodModel ... }
/// }
class RealizationVsBillingModel {
  final BillingPeriodModel monthly;
  final BillingPeriodModel nonMonthly;

  RealizationVsBillingModel({
    required this.monthly,
    required this.nonMonthly,
  });

  factory RealizationVsBillingModel.fromJson(Map<String, dynamic> json) {
    return RealizationVsBillingModel(
      monthly: json['monthly'] != null
          ? BillingPeriodModel.fromJson(json['monthly'] as Map<String, dynamic>)
          : BillingPeriodModel.empty(),
      nonMonthly: json['non_monthly'] != null
          ? BillingPeriodModel.fromJson(json['non_monthly'] as Map<String, dynamic>)
          : BillingPeriodModel.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthly': monthly.toJson(),
      'non_monthly': nonMonthly.toJson(),
    };
  }

  factory RealizationVsBillingModel.empty() {
    return RealizationVsBillingModel(
      monthly: BillingPeriodModel.empty(),
      nonMonthly: BillingPeriodModel.empty(),
    );
  }
}