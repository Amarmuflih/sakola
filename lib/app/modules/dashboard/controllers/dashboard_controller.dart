import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakola/app/routes/app_pages.dart';
import 'package:sakola/data/models/dashboard/FinancialOverviewModel.dart';
import 'package:sakola/data/models/dashboard/GenderBreakdownChartModel.dart';
import 'package:sakola/data/models/dashboard/OperationalCostPieChartModel.dart';
import 'package:sakola/data/models/dashboard/RealizationVsBillingModel.dart';
import 'package:sakola/data/models/dashboard/SchoolGroupModel.dart';
import 'package:sakola/data/models/dashboard/SchoolYearModel.dart';
import 'package:sakola/data/models/dashboard/StudentListRegisterPerYearModel.dart';
import 'package:sakola/repository/dashboard_repository.dart';
import 'package:sakola/services/storage_service.dart';

class DashboardController extends GetxController {
  final DashboardRepository _dashboardRepository = DashboardRepository();

  // --- SCROLL CONTROLLER UNTUK AUTO-SCROLL CHART ---
  final ScrollController sppScrollController = ScrollController();

  // --- FILTER STATE ---
  final RxString schoolYearId = '11'.obs;
  final RxString schoolGroupId = ''.obs;

  final RxList<SchoolYear> schoolYears = <SchoolYear>[].obs;
  final RxList<SchoolGroup> schoolGroups = <SchoolGroup>[].obs;
  final Rx<SchoolYear?> selectedSchoolYear = Rx<SchoolYear?>(null);
  final Rx<SchoolGroup?> selectedSchoolGroup = Rx<SchoolGroup?>(null);
  final RxBool isLoadingFilters = false.obs;
  final RxBool isFilterLoading = false.obs;

  // --- LOADING STATE ---
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // --- INTERACTIVE CHART STATE ---
  final RxInt selectedSppMonthIndex = (-1).obs;

  void showSppTooltip(int index) {
    selectedSppMonthIndex.value = index;
  }

  void hideSppTooltip() {
    selectedSppMonthIndex.value = -1;
  }

  // --- DATA STATE ---
  final Rx<GenderBreakdownChartModel> studentRegisterChart =
      GenderBreakdownChartModel.empty().obs;
  final Rx<StudentListRegisterPerYearModel> studentListRegisterPerYear =
      StudentListRegisterPerYearModel.empty().obs;
  final Rx<GenderBreakdownChartModel> studentGraduatedChart =
      GenderBreakdownChartModel.empty().obs;
  final Rx<GenderBreakdownChartModel> studentActiveChart =
      GenderBreakdownChartModel.empty().obs;
  final Rx<RealizationVsBillingModel> realizationVsBilling =
      RealizationVsBillingModel.empty().obs;
  final Rx<OperationalCostPieChartModel> operationalCostPieChart =
      OperationalCostPieChartModel.empty().obs;
  final Rx<GenderBreakdownChartModel> teacherChart =
      GenderBreakdownChartModel.empty().obs;
  final Rx<FinancialOverviewModel> financialOverview =
      FinancialOverviewModel.empty().obs;

  // --- HEADER STATE ---
  final RxString userName = ''.obs;
  final RxInt notificationCount = 0.obs;
  final RxInt approvalCount = 0.obs;
  final RxBool hasLoadedOnce = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserName();
    _loadFilters();
  }

  void _loadUserName() {
    try {
      final userJson = StorageService.user;
      if (userJson.isNotEmpty) {
        final map = jsonDecode(userJson) as Map<String, dynamic>;
        userName.value = map['name'] ?? '';
      }
    } catch (e) {
      userName.value = '';
    }
  }

  Future<void> _loadFilters() async {
    isLoadingFilters.value = true;
    try {
      final results = await Future.wait([
        _dashboardRepository.getSchoolYears(),
        _dashboardRepository.getSchoolGroups(),
      ]);

      final years = results[0] as List<SchoolYear>;
      final groups = results[1] as List<SchoolGroup>;

      schoolYears.assignAll(years);
      schoolGroups.assignAll(groups);

      if (years.isNotEmpty) {
        final currentLabel = _computeCurrentAcademicYearLabel();
        SchoolYear? current;
        for (final y in years) {
          if (y.label == currentLabel) {
            current = y;
            break;
          }
        }

        SchoolYear? active;
        if (current == null) {
          for (final y in years) {
            if (y.isActive == true) {
              active = y;
              break;
            }
          }
        }

        selectedSchoolYear.value = current ?? active ?? years.first;
        schoolYearId.value = selectedSchoolYear.value!.id;
      }

      if (groups.isNotEmpty) {
        selectedSchoolGroup.value = groups.first;
        schoolGroupId.value = selectedSchoolGroup.value!.id;
      }
    } catch (e) {
      // Fallback ditangani
    }
    isLoadingFilters.value = false;

    await fetchAllDashboardData();
  }

  String _computeCurrentAcademicYearLabel() {
    final now = DateTime.now();
    const startMonth = 7; // Juli
    if (now.month >= startMonth) {
      return '${now.year}/${now.year + 1}';
    } else {
      return '${now.year - 1}/${now.year}';
    }
  }

  static const List<String> _monthAbbreviations = [
    'jan', 'feb', 'mar', 'apr', 'mei', 'jun', 'jul', 'agu', 'sep', 'okt', 'nov', 'des',
  ];
  static const List<String> _monthAbbreviationsEn = [
    'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec',
  ];

  int? _findCurrentMonthIndex(List<String> months) {
    final now = DateTime.now();
    final targetId = _monthAbbreviations[now.month - 1];
    final targetEn = _monthAbbreviationsEn[now.month - 1];

    for (int i = 0; i < months.length; i++) {
      final m = months[i].toLowerCase();
      if (m.startsWith(targetId) || m.startsWith(targetEn)) {
        return i;
      }
    }
    return null;
  }

  Future<void> changeSchoolYear(SchoolYear year) async {
    if (selectedSchoolYear.value?.id == year.id) return;
    selectedSchoolYear.value = year;
    schoolYearId.value = year.id;
    hideSppTooltip();

    isFilterLoading.value = true;
    try {
      await fetchAllDashboardData();
    } finally {
      isFilterLoading.value = false;
    }
  }

  Future<void> changeSchoolGroup(SchoolGroup group) async {
    if (selectedSchoolGroup.value?.id == group.id) return;
    selectedSchoolGroup.value = group;
    schoolGroupId.value = group.id;
    hideSppTooltip(); 

    isFilterLoading.value = true;
    try {
      await fetchAllDashboardData();
    } finally {
      isFilterLoading.value = false;
    }
  }

  Future<void> fetchAllDashboardData() async {
    isLoading.value = true;
    errorMessage.value = '';

    final results = await Future.wait([
      _fetchStudentRegisterChart(),
      _fetchStudentListRegisterPerYear(),
      _fetchStudentGraduatedChart(),
      _fetchStudentActiveChart(),
      _fetchRealizationVsBilling(),
      _fetchOperationalCostPieChart(),
      _fetchTeacherChart(),
      _fetchFinancialOverview(),
    ]);

    final allFailed = results.every((success) => success == false);
    if (allFailed) {
      errorMessage.value =
          'Gagal memuat data dashboard. Periksa koneksi internet Anda.';
    }

    // Eksekusi Auto-Scroll jika data chart tersedia
    final months = financialOverview.value.data.sppChart.categories;
    if (months.isNotEmpty) {
      final currentIndex = _findCurrentMonthIndex(months) ?? (months.length - 1);
      _scrollToMonth(currentIndex, months.length);
    }

    hasLoadedOnce.value = true;
    isLoading.value = false;
  }

  // --- FUNGSI AUTO SCROLL KE BULAN SAAT INI ---
  void _scrollToMonth(int index, int totalMonths) {
    // Beri jeda sedikit (300ms) agar UI selesai merender lebar layarnya dulu
    Future.delayed(const Duration(milliseconds: 300), () {
      if (sppScrollController.hasClients && totalMonths > 0) {
        final maxScroll = sppScrollController.position.maxScrollExtent;
        
        // Jika maxScroll > 0 berarti tampilan sedang overflow/bisa di-scroll (layar HP)
        if (maxScroll > 0) {
          final viewport = sppScrollController.position.viewportDimension;
          final totalWidth = maxScroll + viewport;
          final barWidth = totalWidth / totalMonths;
          
          // Hitung offset agar bulan ini posisinya ada di tengah-tengah layar
          double targetOffset = (index * barWidth) - (viewport / 2) + (barWidth / 2);
          
          if (targetOffset < 0) targetOffset = 0;
          if (targetOffset > maxScroll) targetOffset = maxScroll;

          sppScrollController.animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 600),
            curve: Curves.fastOutSlowIn,
          );
        }
      }
    });
  }

  Future<bool> _fetchStudentRegisterChart() async {
    try {
      final data = await _dashboardRepository.getStudentRegisterChart(
        schoolYearId: schoolYearId.value,
        schoolGroupId: schoolGroupId.value,
      );
      studentRegisterChart.value = data;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _fetchStudentListRegisterPerYear() async {
    try {
      final data = await _dashboardRepository.getStudentListRegisterPerYear(
        schoolGroupId: schoolGroupId.value,
      );
      studentListRegisterPerYear.value = data;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _fetchStudentGraduatedChart() async {
    try {
      final data = await _dashboardRepository.getStudentGraduatedChart(
        schoolYearId: schoolYearId.value,
        schoolGroupId: schoolGroupId.value,
      );
      studentGraduatedChart.value = data;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _fetchStudentActiveChart() async {
    try {
      final data = await _dashboardRepository.getStudentActiveChart(
        schoolYearId: schoolYearId.value,
        schoolGroupId: schoolGroupId.value,
      );
      studentActiveChart.value = data;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _fetchRealizationVsBilling() async {
    try {
      final data = await _dashboardRepository.getRealizationVsBilling(
        schoolYearId: schoolYearId.value,
        schoolGroupId: schoolGroupId.value,
      );
      realizationVsBilling.value = data;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _fetchOperationalCostPieChart() async {
    try {
      final now = DateTime.now();
      final data = await _dashboardRepository.getOperationalCostPieChart(
        schoolGroupId: schoolGroupId.value,
        schoolYear: now.year.toString(),
      );
      operationalCostPieChart.value = data;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _fetchTeacherChart() async {
    try {
      final data = await _dashboardRepository.getTeacherChart(
        schoolGroupId: schoolGroupId.value,
      );
      teacherChart.value = data;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _fetchFinancialOverview() async {
    try {
      final data = await _dashboardRepository.getFinancialOverview(
        schoolYearId: schoolYearId.value,
      );
      financialOverview.value = data;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> refreshData() async {
    await fetchAllDashboardData();
  }

  Future<void> logout() async {
    await StorageService.logout();
    Get.offAllNamed(Routes.SIGN_IN);
  }
 
  @override
  void onClose() {
    sppScrollController.dispose();
    _dashboardRepository.dispose();
    super.onClose();
  }
}