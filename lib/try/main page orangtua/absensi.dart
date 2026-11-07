import 'package:flutter/material.dart';

class Absensi extends StatefulWidget {
  const Absensi({Key? key}) : super(key: key);

  @override
  State<Absensi> createState() => _AbsensiState();
}

class _AbsensiState extends State<Absensi> {
  // --- STATE MANAGEMENT ---
  DateTime _currentMonth = DateTime(2024, 10); // Mulai dari Oktober 2024
  String? _selectedDateKey; // Menyimpan tanggal yang sedang di-tap

  // --- DATA DUMMY ---
  // Key: "YYYY-MM-DD", Value: "masuk" | "izin" | "alpha"
  final Map<String, String> _attendanceData = {};

  // Data dummy tambahan untuk keterangan/alasan tidak masuk
  final Map<String, String> _absenceReasons = {};

  @override
  void initState() {
    super.initState();
    _generateDummyData();
  }

  // Membuat data dummy agar saat pindah bulan, kalender berubah
  void _generateDummyData() {
    // Data Spesifik Oktober 2024 (Mirip seperti gambar)
    _attendanceData["2024-10-01"] = "masuk";
    _attendanceData["2024-10-02"] = "izin";
    _attendanceData["2024-10-03"] = "masuk";
    _attendanceData["2024-10-04"] = "masuk";
    _attendanceData["2024-10-05"] = "alpha";
    _attendanceData["2024-10-07"] = "masuk";
    _attendanceData["2024-10-08"] = "masuk";
    _attendanceData["2024-10-09"] = "masuk";
    _attendanceData["2024-10-10"] = "masuk";
    _attendanceData["2024-10-11"] = "masuk";
    _attendanceData["2024-10-12"] = "masuk";
    _attendanceData["2024-10-14"] = "masuk";
    _attendanceData["2024-10-15"] = "masuk";
    _attendanceData["2024-10-16"] = "masuk";
    _attendanceData["2024-10-17"] = "masuk";
    _attendanceData["2024-10-18"] = "izin";

    // Alasan spesifik untuk tanggal yang tidak masuk
    _absenceReasons["2024-10-02"] =
        "Izin tidak masuk karena ada acara keluarga";
    _absenceReasons["2024-10-05"] = "Tanpa keterangan dari wali murid";
    _absenceReasons["2024-10-18"] = "Sakit demam";

    // Random data untuk September & November agar terlihat berubah saat di-tap
    for (int i = 1; i <= 28; i++) {
      if (i % 7 != 0) {
        // Bukan hari minggu
        _attendanceData["2024-09-${i.toString().padLeft(2, '0')}"] = i % 5 == 0
            ? "izin"
            : "masuk";
        _attendanceData["2024-11-${i.toString().padLeft(2, '0')}"] = i % 8 == 0
            ? "alpha"
            : "masuk";

        // Isi alasan random
        if (i % 5 == 0)
          _absenceReasons["2024-09-${i.toString().padLeft(2, '0')}"] =
              "Izin keperluan keluarga";
        if (i % 8 == 0)
          _absenceReasons["2024-11-${i.toString().padLeft(2, '0')}"] =
              "Tidak ada kabar";
      }
    }
  }

  // --- LOGIKA PERHITUNGAN ---
  List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  void _changeMonth(int increment) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + increment,
        1,
      );
      _selectedDateKey = null; // Reset pilihan saat pindah bulan
    });
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  int _getStartWeekday(int year, int month) {
    int weekday = DateTime(year, month, 1).weekday;
    return weekday == 7 ? 0 : weekday; // Mengubah Minggu dari 7 ke 0
  }

  Map<String, int> _calculateSummary() {
    int masuk = 0;
    int izin = 0;
    int alpha = 0;

    int days = _getDaysInMonth(_currentMonth.year, _currentMonth.month);
    for (int i = 1; i <= days; i++) {
      String dateKey =
          "${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}-${i.toString().padLeft(2, '0')}";
      if (_attendanceData.containsKey(dateKey)) {
        if (_attendanceData[dateKey] == 'masuk') masuk++;
        if (_attendanceData[dateKey] == 'izin') izin++;
        if (_attendanceData[dateKey] == 'alpha') alpha++;
      }
    }
    return {'masuk': masuk, 'izin': izin, 'alpha': alpha};
  }

  @override
  Widget build(BuildContext context) {
    final summary = _calculateSummary();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Absensi',
          style: TextStyle(
            fontFamily: 'Alexandria',
            color: Color(0xFF31313E),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      // SafeArea agar konten tidak menabrak notch/status bar di berbagai HP
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),

              // 1. TOMBOL BULAN (PREV / NEXT)
              _buildMonthSelector(),

              const SizedBox(height: 20),

              const Divider(height: 1, color: Color(0xFFE5E7EB)),

              const SizedBox(height: 16),

              // 2. RINGKASAN KEHADIRAN (Masuk, Ijin, Alpha)
              _buildSummaryRow(summary),

              const SizedBox(height: 16),

              const Divider(height: 1, color: Color(0xFFE5E7EB)),

              const SizedBox(height: 24),

              // 3. HEADER HARI (MIN, SEN, SEL, dst)
              _buildDaysHeader(),

              const SizedBox(height: 16),

              // 4. GRID KALENDER DINAMIS
              _buildCalendarGrid(context),

              const SizedBox(height: 32),

              // 5. KETERANGAN (LEGEND)
              _buildLegendBox(),

              // 6. KARTU DETAIL ALASAN (Hanya muncul saat tanggal diklik)
              _buildDetailReasonCard(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildMonthSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tombol Bulan Sebelumnya
          InkWell(
            onTap: () => _changeMonth(-1),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Icon(
                Icons.chevron_left,
                color: Color(0xFF31313E),
                size: 20,
              ),
            ),
          ),
          // Teks Bulan & Tahun
          Text(
            '${months[_currentMonth.month - 1]} ${_currentMonth.year}',
            style: const TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF31313E),
            ),
          ),
          // Tombol Bulan Selanjutnya
          InkWell(
            onTap: () => _changeMonth(1),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Icon(
                Icons.chevron_right,
                color: Color(0xFF31313E),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(Map<String, int> summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSummaryItem(
            summary['masuk'].toString(),
            'Masuk',
            Icons.how_to_reg,
          ),
          Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
          _buildSummaryItem(
            summary['izin'].toString(),
            'Ijin',
            Icons.mark_email_unread_outlined,
          ),
          Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
          _buildSummaryItem(
            summary['alpha'].toString(),
            'Alpha',
            Icons.help_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String count, String label, IconData icon) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF31313E),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF7F3FBF)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaysHeader() {
    final days = ['MIN', 'SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          return SizedBox(
            width: 32,
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Alexandria',
                color: day == 'MIN' ? const Color(0xFFE53935) : Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    int daysInMonth = _getDaysInMonth(_currentMonth.year, _currentMonth.month);
    int startWeekday = _getStartWeekday(
      _currentMonth.year,
      _currentMonth.month,
    );
    int totalCells = daysInMonth + startWeekday;

    double screenWidth = MediaQuery.of(context).size.width;
    double availableWidth = screenWidth - 48;
    double cellWidth = (availableWidth - (8 * 6)) / 7;
    double cellHeight = 55;
    double childAspectRatio = cellWidth / cellHeight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: totalCells,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 16,
          crossAxisSpacing: 8,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) {
          if (index < startWeekday) {
            return const SizedBox();
          }

          int day = index - startWeekday + 1;
          String dateKey =
              "${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
          String? status = _attendanceData[dateKey];
          bool isSelected = _selectedDateKey == dateKey;

          Color underlineColor = Colors.transparent;
          if (status == 'masuk') {
            underlineColor = const Color(0xFF4CAF50);
          }
          if (status == 'izin') {
            underlineColor = const Color(0xFFF5A623);
          }
          if (status == 'alpha') {
            underlineColor = const Color(0xFFE0E0FF);
          }

          bool isSunday = index % 7 == 0;

          // Warna teks berubah jadi putih saat di-tap/dipilih
          Color textColor = isSelected
              ? Colors.white
              : (isSunday ? const Color(0xFFE53935) : const Color(0xFF31313E));

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDateKey = dateKey;
              });
            },
            child: Container(
              decoration: isSelected
                  ? BoxDecoration(
                      color: const Color(
                        0xFF31313E,
                      ), // Background gelap saat dipilih
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.toString(),
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 3,
                    width: 24,
                    decoration: BoxDecoration(
                      color: underlineColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLegendBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Keterangan',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF31313E),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildLegendItem(const Color(0xFF4CAF50), 'Masuk'),
              const Spacer(),
              _buildLegendItem(const Color(0xFFF5A623), 'Izin'),
              const Spacer(),
              _buildLegendItem(const Color(0xFFE0E0FF), 'Alpha'),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // WIDGET BARU: Menampilkan kartu keterangan saat tanggal diklik
  Widget _buildDetailReasonCard() {
    // Jika tidak ada tanggal yang dipilih, jangan tampilkan apa-apa
    if (_selectedDateKey == null) return const SizedBox();

    String? status = _attendanceData[_selectedDateKey];

    // Opsional: Jika status masuk/hadir tidak perlu keterangan detail, hilangkan komentar ini
    // if (status == null || status == 'masuk') return const SizedBox();

    DateTime parsedDate = DateTime.parse(_selectedDateKey!);
    String formattedDate =
        "${parsedDate.day} ${months[parsedDate.month - 1]} ${parsedDate.year}";

    // Ambil keterangan atau fallback teks
    String reason =
        _absenceReasons[_selectedDateKey] ??
        "Tidak ada catatan untuk tanggal ini.";

    Color statusColor = Colors.grey;
    String statusLabel = 'Tidak Diketahui';

    if (status == 'masuk') {
      statusColor = const Color(0xFF4CAF50);
      statusLabel = 'Masuk';
      reason = "Siswa hadir dan mengikuti pelajaran dengan baik.";
    } else if (status == 'izin') {
      statusColor = const Color(0xFFF5A623);
      statusLabel = 'Izin';
    } else if (status == 'alpha') {
      statusColor = const Color(0xFFE0E0FF);
      statusLabel = 'Alpha';
    }

    return Container(
      margin: const EdgeInsets.only(top: 16, left: 24, right: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF31313E),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusLabel,
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            reason,
            style: const TextStyle(
              fontFamily: 'Alexandria',
              color: Colors.grey,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
