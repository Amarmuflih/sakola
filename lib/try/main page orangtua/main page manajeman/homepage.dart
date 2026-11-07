import 'package:flutter/material.dart';

class HomeManajemen extends StatefulWidget {
  const HomeManajemen({Key? key}) : super(key: key);

  @override
  State<HomeManajemen> createState() => _HomeManajemenState();
}

class _HomeManajemenState extends State<HomeManajemen> {
  // State untuk melacak bulan yang dipilih pada grafik (Index 4 = 'Mei')
  int _selectedMonthPendapatan = 4;
  int _selectedMonthPengeluaran = 4;

  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Ok',
  ];

  // Data koordinat titik Y pada grafik (0.0 sampai 1.0)
  final List<double> _chartPoints = [
    0.2,
    0.4,
    0.2,
    0.6,
    0.1,
    0.7,
    0.5,
    0.8,
    0.3,
    0.9,
  ];

  // Data dinamis nominal per bulan untuk Tooltip
  final List<String> _tooltipPendapatan = [
    'Rp 42,000,000',
    'Rp 48,500,000',
    'Rp 43,200,000',
    'Rp 52,100,000',
    'Rp 57,400,000',
    'Rp 64,800,000',
    'Rp 59,300,000',
    'Rp 71,200,000',
    'Rp 46,500,000',
    'Rp 82,000,000',
  ];

  final List<String> _tooltipPengeluaran = [
    'Rp 12,500,000',
    'Rp 18,200,000',
    'Rp 14,100,000',
    'Rp 19,800,000',
    'Rp 15,000,000',
    'Rp 17,300,000',
    'Rp 14,800,000',
    'Rp 21,500,000',
    'Rp 16,400,000',
    'Rp 24,000,000',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),

              _buildAlertBanner(),
              const SizedBox(height: 20),

              _buildPendapatanCard(),
              const SizedBox(height: 16),

              _buildPengeluaranCard(),
              const SizedBox(height: 16),

              _buildPengeluaranTertinggiCard(),
              const SizedBox(height: 16),

              _buildStatCard(
                'Total Siswa',
                '3,654',
                '+1.2%',
                Colors.blue.shade100,
                '👨‍🎓',
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                'Total Guru',
                '284',
                '+1.2%',
                Colors.orange.shade100,
                '👨‍🏫',
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                'Total Karyawan',
                '163',
                '-2%',
                Colors.grey.shade200,
                '👨‍💼',
                isNegative: true,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildSmallStatCard(
                      'Siswa Masuk',
                      '1,052',
                      Icons.person_add_alt_1,
                      const Color(0xFF9155DF),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSmallStatCard(
                      'Siswa Keluar',
                      '25',
                      Icons.person_remove_alt_1,
                      const Color(0xFFE53935),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildStatistikSiswaCard(),
              const SizedBox(height: 24),

              _buildInventarisSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // WIDGET BUILDERS
  // ===========================================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Icon(Icons.person, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Selamat datang,',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                'Ruslan Hamidin',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  color: Color(0xFF31313E),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            InkWell(
              onTap: () {
                // --- FUNGSI TAP NOTIFIKASI ---
                Navigator.pushNamed(context, '/notifikasi');
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF31313E),
                ),
              ),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlertBanner() {
    return InkWell(
      // --- FUNGSI TAP PERSETUJUAN ---
      onTap: () {
        Navigator.pushNamed(context, '/persetujuan_manajemen');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Color(0xFFF5A623),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Ada 2 persetujuan perlu ditinjau',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  color: Color(0xFF31313E),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF31313E), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPendapatanCard() {
    return _buildBaseChartCard(
      title: 'Pendapatan',
      amount: 'Rp 1,473,000,000', // Total tahunan
      badgeText: '+20%',
      badgeColor: const Color(0xFFE8F5E9),
      badgeTextColor: const Color(0xFF4CAF50),
      icon: Icons.trending_up_rounded,
      chartColor: const Color(0xFF9155DF),
      selectedMonthIndex: _selectedMonthPendapatan,
      monthlyAmounts: _tooltipPendapatan,
      onMonthSelected: (index) {
        setState(() {
          _selectedMonthPendapatan = index;
        });
      },
    );
  }

  Widget _buildPengeluaranCard() {
    return _buildBaseChartCard(
      title: 'Pengeluaran',
      amount: 'Rp 773,000,000', // Total tahunan
      badgeText: '-5%',
      badgeColor: const Color(0xFFE8F5E9),
      badgeTextColor: const Color(0xFF4CAF50),
      icon: Icons.trending_down_rounded,
      chartColor: const Color(0xFFE53935),
      selectedMonthIndex: _selectedMonthPengeluaran,
      monthlyAmounts: _tooltipPengeluaran,
      onMonthSelected: (index) {
        setState(() {
          _selectedMonthPengeluaran = index;
        });
      },
    );
  }

  Widget _buildBaseChartCard({
    required String title,
    required String amount,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required IconData icon,
    required Color chartColor,
    required int selectedMonthIndex,
    required List<String> monthlyAmounts,
    required Function(int) onMonthSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: chartColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Alexandria',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      'Tahun ini - 2024',
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    color: badgeTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            amount,
            style: const TextStyle(
              fontFamily: 'Alexandria',
              color: Color(0xFF31313E),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 24),

          // CHART LINE DINAMIS
          LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              double dotX = width * (selectedMonthIndex / 9);

              // Hitung posisi horizontal tooltip agar tidak keluar dari area layar
              double tooltipWidth = 100;
              double tooltipX = dotX - (tooltipWidth / 2);
              if (tooltipX < 0) tooltipX = 0;
              if (tooltipX > width - tooltipWidth)
                tooltipX = width - tooltipWidth;

              return SizedBox(
                height: 100,
                width: width,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(width, 100),
                      painter: LineChartPainter(
                        lineColor: chartColor,
                        dataPoints: _chartPoints,
                        selectedIndex: selectedMonthIndex,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: tooltipX,
                      child: Container(
                        width: tooltipWidth,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF31313E),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          monthlyAmounts[selectedMonthIndex], // Teks berubah sesuai index bulan
                          style: const TextStyle(
                            fontFamily: 'Alexandria',
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),

          // LABEL BULAN YANG BISA DI-TAP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_months.length, (index) {
              bool isSelected = index == selectedMonthIndex;
              return GestureDetector(
                onTap: () => onMonthSelected(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 2,
                  ), // Memperluas area tap
                  color: Colors.transparent,
                  child: Text(
                    _months[index],
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 10,
                      color: isSelected ? const Color(0xFF31313E) : Colors.grey,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPengeluaranTertinggiCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.pie_chart_outline,
                  color: Color(0xFFE53935),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Pengeluaran Tertinggi',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Tahun ini - 2024',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              height: 120,
              width: 240,
              child: CustomPaint(
                painter: HalfDonutPainter(
                  colors: const [
                    Color(0xFF7F3FBF),
                    Color(0xFFF5A623),
                    Color(0xFF4CAF50),
                    Color(0xFF4B5563),
                  ],
                  proportions: const [0.4, 0.25, 0.2, 0.15],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildLegendRow('Bangunan', '245,000,000', const Color(0xFF7F3FBF)),
          _buildLegendRow(
            'Operasional',
            '204,000,000',
            const Color(0xFFF5A623),
          ),
          _buildLegendRow('Inventaris', '204,000,000', const Color(0xFF4CAF50)),
          _buildLegendRow('Lainnya', '120,000,000', const Color(0xFF4B5563)),
        ],
      ),
    );
  }

  Widget _buildLegendRow(String label, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontFamily: 'Alexandria',
              color: Color(0xFF31313E),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String amount,
    String badge,
    Color bgColor,
    String emoji, {
    bool isNegative = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                Text(
                  amount,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    color: Color(0xFF31313E),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isNegative
                  ? const Color(0xFFFFEBEE)
                  : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontFamily: 'Alexandria',
                color: isNegative
                    ? const Color(0xFFE53935)
                    : const Color(0xFF4CAF50),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: const TextStyle(
              fontFamily: 'Alexandria',
              color: Color(0xFF31313E),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistikSiswaCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF9155DF),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Statistik Siswa',
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Tahun ini - 2024',
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSiswaGenderRow(
                  'Laki laki',
                  '1,654',
                  const Color(0xFF7F3FBF),
                ),
                const SizedBox(height: 12),
                _buildSiswaGenderRow(
                  'Perempuan',
                  '2,000',
                  const Color(0xFFF5A623),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            height: 160,
            child: CustomPaint(
              painter: VerticalHalfDonutPainter(
                colors: const [Color(0xFF7F3FBF), Color(0xFFF5A623)],
                proportions: const [0.45, 0.55],
              ),
            ),
          ),
        ],
      ),
    );
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
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            color: Color(0xFF31313E),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildInventarisSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.inventory_2_outlined,
                    color: Color(0xFF31313E),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Inventaris',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              // --- FUNGSI TAP LAPORAN ---
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/laporan_manajemen');
                },
                child: Row(
                  children: const [
                    Text(
                      'Lihat Laporan',
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_outward_rounded,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '553 Item',
            style: TextStyle(
              fontFamily: 'Alexandria',
              color: Color(0xFF31313E),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildInventarisBox(
                'Elektronik',
                '150 Items',
                Icons.computer_outlined,
              ),
              _buildInventarisBox(
                'Alat Fasilitas',
                '200 Items',
                Icons.chair_alt_outlined,
              ),
              _buildInventarisBox(
                'Buku Perpustakaan',
                '150 Items',
                Icons.book_outlined,
              ),
              _buildInventarisBox(
                'Lainnya',
                '53 Items',
                Icons.grid_view_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventarisBox(String title, String qty, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: const Color(0xFF9155DF), size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
              Text(
                qty,
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  color: Color(0xFF31313E),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// CUSTOM PAINTERS
// ===========================================================================

class LineChartPainter extends CustomPainter {
  final Color lineColor;
  final List<double> dataPoints;
  final int selectedIndex;

  LineChartPainter({
    required this.lineColor,
    required this.dataPoints,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [lineColor.withOpacity(0.2), lineColor.withOpacity(0.0)],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    Paint gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;
    for (int i = 0; i < 10; i++) {
      double dx = size.width / 9 * i;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), gridPaint);
    }

    Path path = Path();
    List<Offset> points = [];

    // Menghitung titik berdasarkan nilai Y dinamis (0.0 - 1.0)
    for (int i = 0; i < dataPoints.length; i++) {
      points.add(
        Offset(size.width * (i / 9), size.height * (1.0 - dataPoints[i])),
      );
    }

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      double xc = (points[i].dx + points[i + 1].dx) / 2;
      double yc = (points[i].dy + points[i + 1].dy) / 2;
      path.quadraticBezierTo(points[i].dx, points[i].dy, xc, yc);
    }
    path.quadraticBezierTo(
      points[points.length - 2].dx,
      points[points.length - 2].dy,
      points.last.dx,
      points.last.dy,
    );

    Path fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // Titik Indikator Dinamis
    Paint dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Paint dotBorderPaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(points[selectedIndex], 5, dotPaint);
    canvas.drawCircle(points[selectedIndex], 5, dotBorderPaint);
  }

  // Wajib true agar lukisan di-render ulang setiap kali state/bulan berubah
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HalfDonutPainter extends CustomPainter {
  final List<Color> colors;
  final List<double> proportions;

  HalfDonutPainter({required this.colors, required this.proportions});

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 35;
    Rect rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height),
      width: size.width - strokeWidth,
      height: (size.height * 2) - strokeWidth,
    );

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    double startAngle = 3.14159;
    double totalAngle = 3.14159;

    for (int i = 0; i < proportions.length; i++) {
      paint.color = colors[i];
      double sweepAngle = totalAngle * proportions[i];
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class VerticalHalfDonutPainter extends CustomPainter {
  final List<Color> colors;
  final List<double> proportions;

  VerticalHalfDonutPainter({required this.colors, required this.proportions});

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 30;

    Rect rect = Rect.fromCenter(
      center: Offset(size.width, size.height / 2),
      width: size.height - strokeWidth,
      height: size.height - strokeWidth,
    );

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    double startAngle = -1.5708;
    double totalAngle = -3.14159; // Berlawanan arah jarum jam

    for (int i = 0; i < proportions.length; i++) {
      paint.color = colors[i];
      double sweepAngle = totalAngle * proportions[i];
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
