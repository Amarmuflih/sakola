import 'package:flutter/material.dart';

class RekapNilai extends StatefulWidget {
  const RekapNilai({Key? key}) : super(key: key);

  @override
  State<RekapNilai> createState() => _RekapNilaiState();
}

class _RekapNilaiState extends State<RekapNilai> {
  // Kategori tab yang aktif
  String _selectedCategory = 'Harian';

  // Daftar kategori untuk tombol scroll
  final List<String> _categories = [
    'Harian',
    'Ujian Tengah Semester',
    'Ujian Akhir',
  ];

  // Data Dummy yang berubah-ubah sesuai tab yang dipilih
  final Map<String, Map<String, dynamic>> _rekapData = {
    'Harian': {
      'rataRata': '85,0',
      'kkm': '70',
      'pesan': 'Pencapaian yang Membanggakan! teruskan prestasi ini',
      'nilai': {
        'Matematika': '85',
        'Bahasa Indonesia': '85',
        'Bahasa Inggris': '85',
        'IPA': '85',
        'IPS': '85',
        'PPKn': '85',
        'Pendidikan Agama': '85',
        'Penjaskes': '85',
      },
    },
    'Ujian Tengah Semester': {
      'rataRata': '88,5',
      'kkm': '70',
      'pesan': 'Hasil UTS yang sangat baik! Pertahankan fokusmu.',
      'nilai': {
        'Matematika': '90',
        'Bahasa Indonesia': '88',
        'Bahasa Inggris': '85',
        'IPA': '89',
        'IPS': '87',
        'PPKn': '90',
        'Pendidikan Agama': '92',
        'Penjaskes': '87',
      },
    },
    'Ujian Akhir': {
      'rataRata': '92,0',
      'kkm': '75',
      'pesan': 'Luar biasa! Semester ini ditutup dengan hasil gemilang 🌟',
      'nilai': {
        'Matematika': '95',
        'Bahasa Indonesia': '90',
        'Bahasa Inggris': '92',
        'IPA': '94',
        'IPS': '89',
        'PPKn': '95',
        'Pendidikan Agama': '96',
        'Penjaskes': '85',
      },
    },
  };

  @override
  Widget build(BuildContext context) {
    // Ambil data berdasarkan kategori yang sedang aktif
    final currentData = _rekapData[_selectedCategory]!;
    final mapNilai = currentData['nilai'] as Map<String, String>;

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
          'Rekap Nilai',
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

          // 1. SCROLLABLE TAB BUTTONS
          _buildTabButtons(),

          const SizedBox(height: 24),

          // 2. KARTU NILAI RATA-RATA & PESAN MOTIVASI
          _buildSummarySection(currentData),

          const SizedBox(height: 24),

          // 3. HEADER TABEL (Mata Pelajaran & Nilai)
          _buildTableHeader(),

          // 4. LIST NILAI (Expanded agar bisa di-scroll terpisah jika panjang)
          Expanded(
            child: ListView.separated(
              itemCount: mapNilai.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFF3F4F6),
              ),
              itemBuilder: (context, index) {
                String subject = mapNilai.keys.elementAt(index);
                String score = mapNilai.values.elementAt(index);
                return _buildGradeItem(subject, score);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildTabButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: _categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF31313E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF31313E)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    color: isSelected ? Colors.white : const Color(0xFF31313E),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummarySection(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Rata-rata
          Row(
            children: [
              // Ikon Grafik Rata-rata dengan background custom
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF9FF),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF3E8FF),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.insights_outlined, // Ikon garis grafik
                  color: Color(0xFF9155DF),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Nilai rata rata',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  color: Color(0xFF31313E),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              // Angka Rata-rata
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data['rataRata'],
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xFF31313E),
                    ),
                  ),
                  Text(
                    'KKM: ${data['kkm']}',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      color: Colors.grey.shade500,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Banner Kuning Pesan Motivasi
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1), // Kuning super muda
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Color(0xFFF5A623),
                  size: 16,
                ), // Bintang oranye/kuning
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data['pesan'],
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      color: Color(0xFF31313E),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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

  Widget _buildTableHeader() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9FAFB), // Latar abu-abu terang
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Mata Pelajaran',
            style: TextStyle(
              fontFamily: 'Alexandria',
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Text(
            'Nilai',
            style: TextStyle(
              fontFamily: 'Alexandria',
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeItem(String subject, String score) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subject,
            style: const TextStyle(
              fontFamily: 'Alexandria',
              color: Color(0xFF31313E),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            score,
            style: const TextStyle(
              fontFamily: 'Alexandria',
              color: Color(0xFF31313E),
              fontSize: 15,
              fontWeight: FontWeight.bold, // Nilai dibuat tebal (bold)
            ),
          ),
        ],
      ),
    );
  }
}
