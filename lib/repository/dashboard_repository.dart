import 'package:sakola/data/models/dashboard/FinancialOverviewModel.dart';
import 'package:sakola/data/models/dashboard/GenderBreakdownChartModel.dart';
import 'package:sakola/data/models/dashboard/OperationalCostPieChartModel.dart';
import 'package:sakola/data/models/dashboard/RealizationVsBillingModel.dart';
import 'package:sakola/data/models/dashboard/SchoolGroupModel.dart';
import 'package:sakola/data/models/dashboard/SchoolYearModel.dart';
import 'package:sakola/data/models/dashboard/StudentListRegisterPerYearModel.dart';
import 'package:sakola/repository/api_respository.dart';

/// Repository khusus untuk seluruh endpoint dashboard.
///
/// Setiap method memanggil [ApiRepository.getData] kemudian
/// memetakan `response.data` ke model yang sesuai, sehingga
/// pemanggil (controller/provider) tidak perlu tahu bentuk JSON mentahnya.
class DashboardRepository {
  final ApiRepository _apiRepository = ApiRepository();

  static const String _basePath = 'v1/dashboard';

  /// GET /dashboard/student_register_charts
  /// Query: school_year_id, school_group_id
  Future<GenderBreakdownChartModel> getStudentRegisterChart({
    required String schoolYearId,
    String? schoolGroupId,
  }) async {
    final response = await _apiRepository.getData(
      '$_basePath/student_register_charts',
      {'school_year_id': schoolYearId, 'school_group_id': schoolGroupId},
      'student_register_charts',
    );
    return GenderBreakdownChartModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// GET /dashboard/student_list_register_per_year
  /// Query: school_group_id
  Future<StudentListRegisterPerYearModel> getStudentListRegisterPerYear({
    String? schoolGroupId,
  }) async {
    final response = await _apiRepository.getData(
      '$_basePath/student_list_register_per_year',
      {'school_group_id': schoolGroupId},
      'student_list_register_per_year',
    );
    return StudentListRegisterPerYearModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// GET /dashboard/student_graduated_charts
  /// Query: school_year_id, school_group_id
  Future<GenderBreakdownChartModel> getStudentGraduatedChart({
    required String schoolYearId,
    String? schoolGroupId,
  }) async {
    final response = await _apiRepository.getData(
      '$_basePath/student_graduated_charts',
      {'school_year_id': schoolYearId, 'school_group_id': schoolGroupId},
      'student_graduated_charts',
    );
    return GenderBreakdownChartModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// GET /dashboard/student_active_charts
  /// Query: school_year_id, school_group_id
  Future<GenderBreakdownChartModel> getStudentActiveChart({
    required String schoolYearId,
    String? schoolGroupId,
  }) async {
    final response = await _apiRepository.getData(
      '$_basePath/student_active_charts',
      {'school_year_id': schoolYearId, 'school_group_id': schoolGroupId},
      'student_active_charts',
    );
    return GenderBreakdownChartModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// GET /dashboard/realization_vs_billing_data
  /// Query: school_group_id, school_year_id
  Future<RealizationVsBillingModel> getRealizationVsBilling({
    required String schoolYearId,
    String? schoolGroupId,
  }) async {
    final response = await _apiRepository.getData(
      '$_basePath/realization_vs_billing_data',
      {'school_group_id': schoolGroupId, 'school_year_id': schoolYearId},
      'realization_vs_billing_data',
    );
    return RealizationVsBillingModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// GET /dashboard/operational_cost_pie_chart
  /// Query: school_group_id, school_year, month
  ///
  /// Catatan: pada saat repository ini dibuat, response API masih
  /// berupa array kosong "[]" sehingga struktur item mengikuti
  /// asumsi generik di [OperationalCostItemModel].
  Future<OperationalCostPieChartModel> getOperationalCostPieChart({
    String? schoolGroupId,
    required String schoolYear,
    String? month,
  }) async {
    final response = await _apiRepository.getData(
      '$_basePath/operational_cost_pie_chart',
      {
        'school_group_id': schoolGroupId,
        'school_year': schoolYear,
        'month': month,
      },
      'operational_cost_pie_chart',
    );
    return OperationalCostPieChartModel.fromJson(response.data);
  }

  /// GET /dashboard/get_teacher_charts
  /// Query: school_group_id
  Future<GenderBreakdownChartModel> getTeacherChart({
    String? schoolGroupId,
  }) async {
    final response = await _apiRepository.getData(
      '$_basePath/get_teacher_charts',
      {'school_group_id': schoolGroupId},
      'get_teacher_charts',
    );
    return GenderBreakdownChartModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// GET /dashboard/financial_overview
  /// Query: school_year_id
  Future<FinancialOverviewModel> getFinancialOverview({
    required String schoolYearId,
  }) async {
    final response = await _apiRepository.getData(
      '$_basePath/financial_overview',
      {'school_year_id': schoolYearId},
      'financial_overview',
    );
    return FinancialOverviewModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  // ===========================================================================
  // FILTER DATA (Tahun Ajaran & Grup) — dipakai buat isi dropdown
  // ===========================================================================

  /// GET /v1/school_years
  ///
  /// Endpoint ini di-paginate (respons ada `nav.totalPage`), jadi di sini
  /// kita loop ambil SEMUA halaman biar dropdown-nya lengkap, bukan cuma
  /// page 1. Sengaja gak pakai `cancelKey` di loop-nya, soalnya kalau pakai
  /// key yang sama tiap request bakal saling cancel satu sama lain
  /// (lihat `_getCancelToken` di [ApiRepository]).
  Future<List<SchoolYear>> getSchoolYears() async {
    final List<SchoolYear> all = [];
    int page = 1;
    int totalPage = 1;

    do {
      final response = await _apiRepository.getData('v1/school_years', {
        'page': page,
      });

      final body = response.data as Map<String, dynamic>;
      final nav = body['nav'] as Map<String, dynamic>?;
      totalPage = nav != null ? (nav['totalPage'] as num? ?? 1).toInt() : 1;

      final list = (body['data'] as List<dynamic>? ?? []);
      all.addAll(
        list.map((e) => SchoolYear.fromJson(e as Map<String, dynamic>)),
      );

      page++;
    } while (page <= totalPage);

    // API gak jamin urutan antar-halaman konsisten (ketauan dari testing:
    // 2037/2038...2050/2051 duluan, baru 2025/2026 nongol paling akhir).
    // Jadi kita sort manual di sini berdasarkan angka tahun di depan label
    // ("2025/2026" -> 2025), ascending.
    all.sort((a, b) {
      final yearA = int.tryParse(a.label.split('/').first) ?? 0;
      final yearB = int.tryParse(b.label.split('/').first) ?? 0;
      return yearA.compareTo(yearB);
    });

    return all;
  }

  /// GET /v1/school_groups
  /// Sama kayak [getSchoolYears], loop semua halaman.
  Future<List<SchoolGroup>> getSchoolGroups() async {
    final List<SchoolGroup> all = [];
    int page = 1;
    int totalPage = 1;

    do {
      final response = await _apiRepository.getData('v1/school_groups', {
        'page': page,
      });

      final body = response.data as Map<String, dynamic>;
      final nav = body['nav'] as Map<String, dynamic>?;
      totalPage = nav != null ? (nav['totalPage'] as num? ?? 1).toInt() : 1;

      final list = (body['data'] as List<dynamic>? ?? []);
      all.addAll(
        list.map((e) => SchoolGroup.fromJson(e as Map<String, dynamic>)),
      );

      page++;
    } while (page <= totalPage);

    return all;
  }

  /// Panggil saat controller/provider di-dispose agar semua
  /// request dashboard yang masih berjalan dibatalkan.
  void dispose() {
    _apiRepository.dispose();
  }
}
