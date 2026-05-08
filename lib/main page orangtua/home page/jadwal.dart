import 'package:flutter/material.dart';

class JadwalPelajaran extends StatefulWidget {
  const JadwalPelajaran({Key? key}) : super(key: key);

  @override
  State<JadwalPelajaran> createState() => _JadwalPelajaranState();
}

class _JadwalPelajaranState extends State<JadwalPelajaran> {
  // --- STATE MANAGEMENT ---
  late DateTime _selectedDate;
  late List<DateTime> _dateList;

  // --- DATA DUMMY JADWAL ---
  // Key menggunakan format YYYY-MM-DD
  final Map<String, List<Map<String, dynamic>>> _scheduleData = {};

  @override
  void initState() {
    super.initState();
    // Set default tanggal ke 15 Oktober 2024 (seperti di screenshot)
    _selectedDate = DateTime(2024, 10, 15);

    // Generate daftar tanggal dari 12 Okt sampai 26 Okt 2024 untuk scroll horizontal
    _dateList = List.generate(
      15,
      (index) => DateTime(2024, 10, 12).add(Duration(days: index)),
    );

    _generateDummyData();
  }

  void _generateDummyData() {
    // Jadwal 15 Oktober (Selasa)
    _scheduleData["2024-10-15"] = [
      {
        'subject': 'Ilmu Pengetahuan Alam',
        'time': '08:00 - 08:45 WIB',
        'isExam': false,
      },
      {
        'subject': 'Ilmu Pengetahuan Alam',
        'time': '08:45 - 09:30 WIB',
        'isExam': false,
      },
      {'subject': 'Istirahat', 'time': '09:30 - 09:45 WIB', 'isExam': false},
      {'subject': 'Matematika', 'time': '09:45 - 10:30 WIB', 'isExam': false},
      {'subject': 'Matematika', 'time': '10:30 - 11:15 WIB', 'isExam': false},
      {
        'subject': 'Pendidikan Agama',
        'time': '11:15 - 12:00 WIB',
        'isExam': false,
      },
      {'subject': 'Istirahat', 'time': '12:00 - 12:30 WIB', 'isExam': false},
    ];

    // Jadwal 16 Oktober (Rabu) - Ada Ujian Harian
    _scheduleData["2024-10-16"] = [
      {
        'subject': 'Ilmu Pengetahuan Alam',
        'time': '08:00 - 08:45 WIB',
        'isExam': false,
      },
      {
        'subject': 'Ilmu Pengetahuan Alam',
        'time': '08:45 - 09:30 WIB',
        'isExam': false,
      },
      {'subject': 'Istirahat', 'time': '09:30 - 09:45 WIB', 'isExam': false},
      {
        'subject': 'Ujian Harian Ilmu Pengetahuan Sosial',
        'time': '09:45 - 10:30 WIB',
        'isExam': true,
      },
      {
        'subject': 'Ujian Harian Ilmu Pengetahuan Sosial',
        'time': '10:30 - 11:15 WIB',
        'isExam': true,
      },
      {
        'subject': 'Pendidikan Agama',
        'time': '11:15 - 12:00 WIB',
        'isExam': false,
      },
      {'subject': 'Istirahat', 'time': '12:00 - 12:30 WIB', 'isExam': false},
    ];

    // Default jadwal kosong untuk hari-hari lain
    for (var date in _dateList) {
      String key = _formatDateKey(date);
      if (!_scheduleData.containsKey(key)) {
        // Jika weekend, kosongkan jadwal
        if (date.weekday == 6 || date.weekday == 7) {
          _scheduleData[key] = [];
        } else {
          _scheduleData[key] = [
            {'subject': 'Belum ada jadwal', 'time': '-', 'isExam': false},
          ];
        }
      }
    }
  }

  // --- LOGIKA HELPER TANGGAL ---
  String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _getShortDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'SEN';
      case 2:
        return 'SEL';
      case 3:
        return 'RAB';
      case 4:
        return 'KAM';
      case 5:
        return 'JUM';
      case 6:
        return 'SAB';
      case 7:
        return 'MIN';
      default:
        return '';
    }
  }

  String _getFullDateIndo(DateTime date) {
    List<String> days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
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

    String dayName = days[date.weekday - 1];
    String monthName = months[date.month - 1];

    return "$dayName, ${date.day} $monthName ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    String currentKey = _formatDateKey(_selectedDate);
    List<Map<String, dynamic>> currentSchedule =
        _scheduleData[currentKey] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF31313E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Jadwal Pelajaran',
          style: TextStyle(
            fontFamily: 'Alexandria',
            color: Color(0xFF31313E),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // 1. SCROLL HORIZONTAL TANGGAL
          _buildDateSelector(),

          const SizedBox(height: 24),

          // 2. HEADER TANGGAL LENGKAP
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _getFullDateIndo(_selectedDate),
              style: const TextStyle(
                fontFamily: 'Alexandria',
                color: Color(0xFF31313E),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 3. LIST JADWAL PELAJARAN
          Expanded(
            child: currentSchedule.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada jadwal hari ini (Libur)',
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        color: Colors.grey.shade500,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: currentSchedule.length,
                    itemBuilder: (context, index) {
                      return _buildScheduleItem(currentSchedule[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET DATE SELECTOR ---
  Widget _buildDateSelector() {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _dateList.length,
        itemBuilder: (context, index) {
          DateTime date = _dateList[index];
          bool isSelected =
              _selectedDate.year == date.year &&
              _selectedDate.month == date.month &&
              _selectedDate.day == date.day;

          // Mengecek apakah hari Sabtu atau Minggu
          bool isWeekend = date.weekday == 6 || date.weekday == 7;

          // Menentukan warna teks berdasarkan seleksi dan weekend
          Color textColor;
          if (isSelected) {
            textColor = Colors.white;
          } else if (isWeekend) {
            textColor = const Color(0xFFE53935); // Merah untuk weekend
          } else {
            textColor =
                Colors.grey.shade600; // Abu-abu untuk weekday tidak dipilih
          }

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF31313E)
                    : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(
                  16,
                ), // Sudut membulat seperti squircle
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF31313E)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getShortDayName(date.weekday),
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: textColor,
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

  // --- WIDGET SCHEDULE ITEM CARD ---
  Widget _buildScheduleItem(Map<String, dynamic> item) {
    bool isExam = item['isExam'] ?? false;
    bool isBreak = item['subject'] == 'Istirahat';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['subject'],
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isBreak ? Colors.grey.shade800 : const Color(0xFF31313E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item['time'],
            style: TextStyle(
              fontFamily: 'Alexandria',
              color: Colors.grey.shade500,
              fontSize: 13,
            ),
          ),

          // Badge Ujian Harian (Muncul hanya jika isExam == true)
          if (isExam) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD), // Background kuning redup
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Ujian Harian',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  color: Color(
                    0xFF856404,
                  ), // Teks kecoklatan/gelap khas warning
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
