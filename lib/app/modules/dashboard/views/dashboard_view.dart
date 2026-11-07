import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sakola/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:sakola/app/widgets/chart_painters.dart';
import 'package:sakola/data/models/dashboard/SchoolGroupModel.dart';
import 'package:sakola/data/models/dashboard/SchoolYearModel.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  static const _bg = Color(0xFFF4F6F9);
  static const _dark = Color(0xFF2D3748);
  static const _purple = Color(0xFF7B61FF);
  static const _red = Color(0xFFFF4D4F);
  static const _green = Color(0xFF23C16B);

  static const _palette = [
    Color(0xFF7B61FF),
    Color(0xFFF2C94C),
    Color(0xFF23C16B),
    Color(0xFF828282),
    Color(0xFF2D9CDB),
    Color(0xFFFF4D4F),
  ];

  static const double _purpleBgHeightRatio = 0.40;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * _purpleBgHeightRatio,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/bg_purple.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 8),
                _buildFilterRow(),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(
                    () => RefreshIndicator(
                      color: _purple,
                      onRefresh: controller.refreshData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        child: _buildContentSheet(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSheet(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child:
          (!controller.hasLoadedOnce.value || controller.isFilterLoading.value)
          ? _buildInitialLoading()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildApprovalBanner(),
                if (controller.approvalCount.value > 0)
                  const SizedBox(height: 16),

                if (controller.errorMessage.value.isNotEmpty) ...[
                  _buildErrorBanner(controller.errorMessage.value),
                  const SizedBox(height: 16),
                ],

                LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        _buildFinancialSection(),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(child: _buildOperationalCostCard()),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildSmallStatCard(
                                'Siswa Daftar',
                                '${controller.studentRegisterChart.value.total}',
                                Icons.person_add_alt_1_rounded,
                                _purple,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSmallStatCard(
                                'Siswa Lulus',
                                '${controller.studentGraduatedChart.value.total}',
                                Icons.school_rounded,
                                _green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Siswa Aktif',
                                '${controller.studentActiveChart.value.total}',
                                const Color(0xFFE3F2FD),
                                const Color(0xFF1E88E5),
                                Icons.emoji_people_rounded,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Total Guru',
                                '${controller.teacherChart.value.total}',
                                const Color(0xFFFFF3E0),
                                const Color(0xFFF57C00),
                                Icons.record_voice_over_rounded,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        _buildStatistikSiswaCard(),
                        const SizedBox(height: 16),

                        _buildListRegisterPerYearCard(),
                        const SizedBox(height: 16),

                        _buildRealizationVsBillingCard(),
                        const SizedBox(height: 16),

                        _buildFinancialOverviewStatusCard(),
                      ],
                    );
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildInitialLoading() {
    return SizedBox(
      height: Get.height * 0.4,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimationWidget.staggeredDotsWave(color: _purple, size: 40),
            const SizedBox(height: 16),
            Text(
              'Menyiapkan data dashboard...',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat datang kembali,',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    controller.userName.value.isEmpty
                        ? 'Memuat...'
                        : controller.userName.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          _buildGlassIconButton(
            icon: Icons.notifications_none_rounded,
            badgeCount: controller.notificationCount.value,
            onTap: () {},
          ),
          const SizedBox(width: 10),
          _buildGlassIconButton(
            icon: Icons.logout_rounded,
            badgeCount: 0,
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required int badgeCount,
    required VoidCallback onTap,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
        if (badgeCount > 0)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _red,
                shape: BoxShape.circle,
                border: Border.all(color: _purple, width: 2),
              ),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              child: Text(
                '$badgeCount',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildApprovalBanner() {
    return Obx(() {
      final count = controller.approvalCount.value;
      if (count <= 0) return const SizedBox.shrink();

      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF3CD), Color(0xFFFFE69C)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFE69C).withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.assignment_late_rounded,
                  color: Color(0xFFF5A623),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Perlu Tindakan',
                      style: TextStyle(
                        color: Color(0xFF856404),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$count persetujuan menunggu tinjauan',
                      style: const TextStyle(
                        color: _dark,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: _dark,
                size: 16,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => _FilterPill<SchoolYear>(
                icon: Icons.calendar_month_rounded,
                label:
                    controller.selectedSchoolYear.value?.label ??
                    'Tahun Ajaran',
                items: controller.schoolYears,
                itemLabel: (y) => y.label,
                onSelected: controller.changeSchoolYear,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => _FilterPill<SchoolGroup>(
                icon: Icons.domain_rounded,
                label: controller.selectedSchoolGroup.value?.name ?? 'Grup',
                items: controller.schoolGroups,
                itemLabel: (g) => g.name,
                onSelected: controller.changeSchoolGroup,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF5C6CB)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.red.shade700,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  //               FINANCIAL SECTION
  // =========================================================
  Widget _buildFinancialSection() {
    return Obx(() {
      final data = controller.financialOverview.value.data;
      final tahunAjaran = controller.selectedSchoolYear.value?.label ?? '-';

      final months = data.sppChart.categories;
      final values = data.sppChart.series
          .map((e) => (e as num).toDouble())
          .toList();
      final selectedIndex = controller.selectedSppMonthIndex.value;

      return LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          final summaryCards = Column(
            children: [
              _buildSummaryCard(
                title: 'Pendapatan',
                amount: _formatRupiah(data.totalPendapatan),

                subtitle: 'Tahun Ajaran $tahunAjaran',
                bgColor: const Color(0xFFFFD600),
                textColor: const Color(0xFF1E1E1E),
                icon: Icons.trending_up_rounded,
              ),
              const SizedBox(height: 16),
              _buildSummaryCard(
                title: 'Pengeluaran',
                amount: _formatRupiah(data.totalPengeluaran),
                subtitle: 'Tahun Ajaran $tahunAjaran',
                bgColor: const Color(0xFF6139B3),
                textColor: Colors.white,
                icon: Icons.account_balance_wallet_outlined,
              ),
            ],
          );

          final chartCard = _buildSoftCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pendapatan SPP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tahun Ajaran $tahunAjaran',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                // Chart di-pass ke dalam
                _buildSPPBarChart(
                  months,
                  values,
                  selectedIndex,
                  controller.showSppTooltip,
                  controller.hideSppTooltip,
                ),
              ],
            ),
          );

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: summaryCards),
                const SizedBox(width: 16),
                Expanded(flex: 6, child: chartCard),
              ],
            );
          } else {
            return Column(
              children: [summaryCards, const SizedBox(height: 16), chartCard],
            );
          }
        },
      );
    });
  }

  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required String subtitle,
    required Color bgColor,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -20,
            child: Icon(icon, size: 100, color: textColor.withOpacity(0.15)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSPPBarChart(
    List<String> months,
    List<double> values,
    int selectedIndex,
    ValueChanged<int> onShow,
    VoidCallback onHide,
  ) {
    if (months.isEmpty || values.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'Belum ada data visualisasi.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final safeMax = maxValue == 0 ? 1.0 : maxValue;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Buat minimal width chart (misal 500px).
        // Kalau layar HP sempit (<500px), chart akan bisa di-scroll ke samping.
        // Tujuannya agar teks angka tidak bertumpuk/turun ke bawah.
        final totalWidth = constraints.maxWidth;
        final chartWidth = totalWidth < 500 ? 500.0 : totalWidth;

        const tooltipWidth = 200.0;
        double tooltipX = 0;

        if (selectedIndex >= 0 && selectedIndex < months.length) {
          final barWidth = chartWidth / months.length;
          final barCenter = (selectedIndex * barWidth) + (barWidth / 2);
          tooltipX = barCenter - (tooltipWidth / 2);

          if (tooltipX < 0) tooltipX = 0;
          if (tooltipX + tooltipWidth > chartWidth)
            tooltipX = chartWidth - tooltipWidth;
        }

        return SizedBox(
          height: 250,
          // SingleChildScrollView memecahkan error right overflow!
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: chartWidth,
              child: Stack(
                children: [
                  // 1. CHART AREA
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(months.length, (i) {
                        final val = values[i];
                        final heightFactor = val / safeMax;
                        final isSelected = i == selectedIndex;

                        String valStr = '0';
                        if (val > 0) {
                          if (val >= 1000000) {
                            valStr = '${(val / 1000000).toStringAsFixed(1)}jt';
                          } else if (val >= 1000) {
                            valStr = '${(val / 1000).toStringAsFixed(1)}rb';
                          } else {
                            valStr = val.toStringAsFixed(0);
                          }
                        }

                        return Expanded(
                          child: GestureDetector(
                            // INTERAKSI: Tekan dan tahan untuk memunculkan
                            onTapDown: (_) => onShow(i),
                            onTapUp: (_) => onHide(),
                            onTapCancel: () => onHide(),
                            behavior: HitTestBehavior.opaque,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  valStr,
                                  maxLines: 1, // Mencegah teks patah ke bawah
                                  softWrap: false,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isSelected
                                        ? const Color(0xFF6139B3)
                                        : const Color(0xFF6139B3),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Flexible(
                                  child: FractionallySizedBox(
                                    heightFactor: heightFactor > 0
                                        ? heightFactor
                                        : 0.01,
                                    child: Container(
                                      width: 22,
                                      decoration: BoxDecoration(
                                        color: val > 0
                                            ? (isSelected
                                                  ? const Color(0xFFFFF04D)
                                                  : const Color(0xFF7E57C2))
                                            : Colors.transparent,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(6),
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  months[i],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // 2. TOOLTIP MELAYANG (Otomatis menyesuaikan posisi)
                  if (selectedIndex >= 0 && values[selectedIndex] >= 0)
                    Positioned(
                      top: 0,
                      left: tooltipX,
                      child: Container(
                        width: tooltipWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              child: Text(
                                months[selectedIndex],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: _dark,
                                ),
                              ),
                            ),
                            Container(height: 1, color: Colors.grey.shade100),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF7E57C2),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'SPP:',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _dark,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _formatRupiah(values[selectedIndex]),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: _dark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  // =========================================================

  Widget _buildOperationalCostCard() {
    return Obx(() {
      final items = controller.operationalCostPieChart.value.items;
      return _buildSoftCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.pie_chart_rounded,
                    color: Color(0xFFF57C00),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Biaya Operasional',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: _dark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (items.isEmpty)
              const Center(
                child: Text(
                  'Belum ada data operasional.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else ...[
              LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: SizedBox(
                      height: 140,
                      width: constraints.maxWidth * 0.8,
                      child: CustomPaint(
                        painter: HalfDonutPainter(
                          colors: _palette,
                          proportions: _getProportions(
                            items
                                .map((e) => (e.value as num).toDouble())
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ...List.generate(
                items.length,
                (i) => _buildLegendRow(
                  items[i].label.toString(),
                  '${items[i].value}',
                  _palette[i % _palette.length],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  List<double> _getProportions(List<double> values) {
    final total = values.fold<double>(0, (sum, val) => sum + val);
    return total == 0
        ? values.map((_) => 0.0).toList()
        : values.map((v) => v / total).toList();
  }

  Widget _buildLegendRow(String label, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: _dark,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String amount,
    Color bgLight,
    Color iconColor,
    IconData icon,
  ) {
    return _buildSoftCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: const TextStyle(
                    color: _dark,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatCard(
    String title,
    String amount,
    IconData icon,
    Color iconColor,
  ) {
    return _buildSoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              color: _dark,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistikSiswaCard() {
    return Obx(() {
      final model = controller.studentActiveChart.value;
      final laki = model.lakiLaki;
      final perempuan = model.perempuan;
      final proportions = _getProportions([
        (laki as num).toDouble(),
        (perempuan as num).toDouble(),
      ]);

      return _buildSoftCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.wc_rounded,
                          color: _purple,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Statistik Siswa',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: _dark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSiswaGenderRow('Laki-laki', '$laki', _palette[0]),
                  const SizedBox(height: 16),
                  _buildSiswaGenderRow('Perempuan', '$perempuan', _palette[1]),
                ],
              ),
            ),
            SizedBox(
              width: 90,
              height: 160,
              child: CustomPaint(
                painter: VerticalHalfDonutPainter(
                  colors: [_palette[0], _palette[1]],
                  proportions: proportions,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSiswaGenderRow(String label, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
            color: _dark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildListRegisterPerYearCard() {
    return Obx(() {
      final model = controller.studentListRegisterPerYear.value;
      return _buildSoftCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_graph_rounded,
                    color: Color(0xFF00ACC1),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Pendaftaran per Tahun',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: _dark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (model.tahun.isEmpty)
              const Text(
                'Belum ada data.',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...List.generate(model.tahun.length, (i) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${model.tahun[i]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: _dark,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.male_rounded,
                            size: 16,
                            color: _palette[0],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${model.lakilaki[i]}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.female_rounded,
                            size: 16,
                            color: _palette[1],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${model.perempuan[i]}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      );
    });
  }

  Widget _buildRealizationVsBillingCard() {
    return Obx(() {
      final model = controller.realizationVsBilling.value;
      return _buildSoftCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EAF6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Color(0xFF3F51B5),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Realisasi vs Tagihan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: _dark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Bulanan'),
            const SizedBox(height: 8),
            ...List.generate(model.monthly.months.length, (i) {
              if (model.monthly.studentBillings[i] == 0 &&
                  model.monthly.studentPayment[i] == 0)
                return const SizedBox.shrink();
              return _buildRealizationRow(
                model.monthly.months[i],
                model.monthly.studentBillings[i],
                model.monthly.studentPayment[i],
              );
            }),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),
            _buildSectionTitle('Non Bulanan'),
            const SizedBox(height: 8),
            ...List.generate(model.nonMonthly.months.length, (i) {
              if (model.nonMonthly.studentBillings[i] == 0 &&
                  model.nonMonthly.studentPayment[i] == 0)
                return const SizedBox.shrink();
              return _buildRealizationRow(
                model.nonMonthly.months[i],
                model.nonMonthly.studentBillings[i],
                model.nonMonthly.studentPayment[i],
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.grey.shade500,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildRealizationRow(String month, num billing, num payment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              month,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _dark,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Tagihan: ${_formatRupiah(billing)}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(
                'Bayar: ${_formatRupiah(payment)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialOverviewStatusCard() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _purple.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _purple.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: _purple, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Status Laporan: ${controller.financialOverview.value.status}',
                style: const TextStyle(
                  fontSize: 13,
                  color: _purple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSoftCard({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(20),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  String _formatRupiah(num value) {
    final str = value.round().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final posFromEnd = str.length - i;
      buffer.write(str[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write('.');
    }
    return 'Rp $buffer';
  }

  void _confirmLogout(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Konfirmasi Logout',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(foregroundColor: Colors.grey.shade700),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterPill<T> extends StatelessWidget {
  const _FilterPill({
    super.key,
    required this.icon,
    required this.label,
    required this.items,
    required this.itemLabel,
    required this.onSelected,
    this.selectedItem,
  });

  final IconData icon;
  final String label;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T> onSelected;
  final T? selectedItem;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      enabled: items.isNotEmpty,
      tooltip: '',
      color: Colors.white,
      elevation: 8,
      offset: const Offset(0, 48),
      constraints: const BoxConstraints(maxWidth: 260, maxHeight: 320),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      onSelected: onSelected,
      itemBuilder: (context) {
        return List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = item == selectedItem;

          return PopupMenuItem<T>(
            value: item,
            padding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF1F3F5) : Colors.white,
              ),
              child: Text(
                itemLabel(item),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ),
          );
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(.35)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
