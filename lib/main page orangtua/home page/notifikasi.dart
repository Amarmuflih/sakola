import 'package:flutter/material.dart';

class Notifikasi extends StatefulWidget {
  const Notifikasi({Key? key}) : super(key: key);

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  // State untuk menyimpan notifikasi yang sedang dibuka detailnya
  Map<String, dynamic>? _selectedNotif;

  // Data Dummy Notifikasi (Perhatikan penambahan field 'isRead')
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'type': 'pembayaran',
      'title': 'Pembayaran SPP Bulan Oktober 2024 Berhasil',
      'description': 'Pembayaran SPP sebesar Rp 345,000 berhasil diterima.',
      'time': '5 min',
      'isRead': false, // Belum dibaca
      'iconUrl': 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
    },
    {
      'id': '2',
      'type': 'tugas',
      'title': 'Tugas Mengarang Cerita Pendek',
      'description':
          'Ada tugas baru untuk dikerjakan, ayo segera cek agar segera dikerjakan.',
      'time': '5 min',
      'isRead': false, // Belum dibaca
      'initials': 'TM',
      'color': const Color(0xFF7F3FBF), // Ungu
    },
    {
      'id': '3',
      'type': 'event',
      'title': 'Event Persami bulan Oktober 2024',
      'description':
          'Pengumuman! Akan diadakan kegiatan Persami pada 21 Oktober 2024.',
      'time': 'Kemarin',
      'isRead': true, // Sudah dibaca
      'iconUrl': 'https://cdn-icons-png.flaticon.com/512/684/684908.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF31313E)),
          onPressed: () {
            if (_selectedNotif != null) {
              // Jika sedang di halaman detail, kembali ke list
              setState(() {
                _selectedNotif = null;
              });
            } else {
              // Keluar dari halaman Notifikasi
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _selectedNotif != null ? 'Detail Notifikasi' : 'Notifikasi',
          style: const TextStyle(
            fontFamily: 'Alexandria',
            color: Color(0xFF31313E),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        // Garis batas tipis di bawah AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFF3F4F6), height: 1.0),
        ),
      ),
      body: _selectedNotif == null ? _buildListView() : _buildDetailView(),
    );
  }

  // ===========================================================================
  // 1. TAMPILAN LIST NOTIFIKASI
  // ===========================================================================
  Widget _buildListView() {
    return ListView.separated(
      itemCount: _notifications.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFF3F4F6), // Garis pembatas abu-abu terang
      ),
      itemBuilder: (context, index) {
        final notif = _notifications[index];
        final bool isRead = notif['isRead'];

        return InkWell(
          onTap: () {
            setState(() {
              // Tandai sebagai sudah dibaca
              notif['isRead'] = true;
              // Buka halaman detail
              _selectedNotif = notif;
            });
          },
          child: Container(
            // Memberikan background biru/ungu sangat muda jika belum dibaca
            color: isRead ? Colors.white : const Color(0xFFF8F9FE),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- IKON NOTIFIKASI ---
                _buildNotificationIcon(notif),

                const SizedBox(width: 16),

                // --- TEKS NOTIFIKASI ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notif['title'],
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                color: const Color(0xFF31313E),
                                // Teks lebih tebal jika belum dibaca
                                fontWeight: isRead
                                    ? FontWeight.w600
                                    : FontWeight.bold,
                                fontSize: 14,
                                height: 1.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            notif['time'],
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              color: Colors.grey.shade500,
                              fontSize: 12,
                              fontWeight: isRead
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['description'],
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper untuk menampilkan ikon notifikasi yang berbeda-beda jenisnya
  Widget _buildNotificationIcon(Map<String, dynamic> notif) {
    if (notif['type'] == 'tugas') {
      // Tampilan Ikon Inisial Tugas (misal: "TM")
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: notif['color'],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            notif['initials'],
            style: const TextStyle(
              fontFamily: 'Alexandria',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    } else {
      // Tampilan Ikon Gambar (SPP atau Event)
      return Container(
        width: 44,
        height: 44,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF9FF), // Latar icon ungu sangat muda
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF3E8FF)),
        ),
        child: Image.network(
          notif['iconUrl'],
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.notifications_active, color: Colors.grey),
        ),
      );
    }
  }

  // ===========================================================================
  // 2. TAMPILAN DETAIL NOTIFIKASI
  // ===========================================================================
  Widget _buildDetailView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildNotificationIcon(_selectedNotif!),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _selectedNotif!['title'],
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    color: Color(0xFF31313E),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _selectedNotif!['time'],
            style: const TextStyle(
              fontFamily: 'Alexandria',
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFF3F4F6), thickness: 1),
          const SizedBox(height: 24),
          Text(
            _selectedNotif!['description'],
            style: const TextStyle(
              fontFamily: 'Alexandria',
              color: Color(0xFF4B5563),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),

          // --- TOMBOL AKSI TAMBAHAN DI DETAIL (Opsional, menyesuaikan tipe) ---
          if (_selectedNotif!['type'] == 'tugas')
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Aksi menuju halaman Tugas
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF31313E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Lihat Tugas',
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else if (_selectedNotif!['type'] == 'pembayaran')
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () {
                  // Aksi menuju Riwayat Tagihan
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Lihat Riwayat Pembayaran',
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    color: Color(0xFF31313E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
