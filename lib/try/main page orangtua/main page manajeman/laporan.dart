import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Laporan extends StatefulWidget {
  const Laporan({super.key});

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  // Data dummy laporan sesuai gambar
  final List<Map<String, dynamic>> _daftarLaporan = [
    {
      'title': 'Laporan Keuangan',
      'icon': Icons.assessment_outlined,
      'color': const Color(0xFF7F3FBF),
    },
    {
      'title': 'Laporan Inventaris',
      'icon': Icons.inventory_2_outlined,
      'color': const Color(0xFF7F3FBF),
    },
    {
      'title': 'Laporan Keluar Masuk Siswa',
      'icon': Icons.school_outlined,
      'color': const Color(0xFF7F3FBF),
    },
    {
      'title': 'Laporan Kinerja Karyawan',
      'icon': Icons.groups_outlined,
      'color': const Color(0xFF7F3FBF),
    },
    {
      'title': 'Laporan Kehadiran Siswa',
      'icon': Icons.list_alt_outlined,
      'color': const Color(0xFF7F3FBF),
    },
  ];

  // --- FUNGSI TAMPIL POPUP DOWNLOAD ---
  void _showDownloadPopup(BuildContext context, String title, IconData icon) {
    DateTime? dariTanggal;
    DateTime? sampaiTanggal;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Popup
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F5FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          icon,
                          color: const Color(0xFF7F3FBF),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF31313E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Pilih tanggal untuk download $title",
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Input Tanggal (Dari & Sampai)
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateInput(
                          label: "Dari Tanggal",
                          date: dariTanggal,
                          onTap: () async {
                            final picked = await _selectDate(context);
                            if (picked != null)
                              setModalState(() => dariTanggal = picked);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDateInput(
                          label: "Sampai Tanggal",
                          date: sampaiTanggal,
                          onTap: () async {
                            final picked = await _selectDate(context);
                            if (picked != null)
                              setModalState(() => sampaiTanggal = picked);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Tombol Aksi
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              (dariTanggal != null && sampaiTanggal != null)
                              ? () => _executeDownloadExcel(
                                  title,
                                  dariTanggal!,
                                  sampaiTanggal!,
                                )
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF1F0FE),
                            foregroundColor: const Color(0xFF7F3FBF),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Download",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Batal",
                            style: TextStyle(
                              color: Color(0xFF31313E),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- HELPER DATE PICKER INPUT ---
  Widget _buildDateInput({
    required String label,
    DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color(0xFF31313E),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  date == null
                      ? "Pilih tanggal"
                      : DateFormat('dd/MM/yyyy').format(date),
                  style: TextStyle(
                    color: date == null ? Colors.grey : Colors.black,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
  }

  // --- SIMULASI DOWNLOAD EXCEL ---
  void _executeDownloadExcel(String title, DateTime start, DateTime end) {
    // Simulasi logic nntinya memanggil excel generator
    Navigator.pop(context); // Tutup popup
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil mengunduh Excel $title"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Laporan",
          style: TextStyle(
            color: Color(0xFF31313E),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: _daftarLaporan.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.82,
          ),
          itemBuilder: (context, index) {
            final item = _daftarLaporan[index];
            return _buildReportCard(item['title'], item['icon'], item['color']);
          },
        ),
      ),
    );
  }

  // --- WIDGET CARD LAPORAN ---
  Widget _buildReportCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F9)),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF31313E),
            ),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: () => _showDownloadPopup(context, title, icon),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              side: BorderSide(color: Colors.grey.shade200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Download",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Icon(
                  Icons.file_download_outlined,
                  color: Colors.grey,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
