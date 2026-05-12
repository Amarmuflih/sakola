import 'package:flutter/material.dart';

// ============================================================================
// 1. MODEL DATA NOTIFIKASI
// ============================================================================
class NotifData {
  final String id;
  final String type;
  final String title;
  final String description;
  final String time;
  final String? initials; // Untuk icon inisial (misal tugas: 'MT')
  final String? iconUrl; // Untuk icon berupa gambar
  final Color? color; // Warna background icon inisial
  bool isRead;

  NotifData({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.time,
    this.initials,
    this.iconUrl,
    this.color,
    this.isRead = false,
  });
}

// ============================================================================
// 2. HALAMAN NOTIFIKASI UTAMA (GABUNGAN ROLE)
// ============================================================================
class Notifikasi extends StatefulWidget {
  const Notifikasi({Key? key}) : super(key: key);

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  NotifData? _selectedNotif;
  String _userRole = 'orang_tua'; // Default role

  // --- DATA DUMMY: ORANG TUA ---
  final List<NotifData> _listOrangTua = [
    NotifData(
      id: 'ot1',
      type: 'pembayaran',
      title: 'Pembayaran SPP Bulan Oktober 2024 Berhasil',
      description: 'Pembayaran SPP sebesar Rp 345,000 berhasil diterima.',
      time: '5 min',
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
      isRead: false,
    ),
    NotifData(
      id: 'ot2',
      type: 'tugas',
      title: 'Tugas Mengarang Cerita Pendek',
      description:
          'Ada tugas baru untuk dikerjakan, ayo segera cek agar segera dikerjakan.',
      time: '1 jam',
      initials: 'TM',
      color: const Color(0xFF7F3FBF),
      isRead: false,
    ),
    NotifData(
      id: 'ot3',
      type: 'event',
      title: 'Event Persami bulan Oktober 2024',
      description:
          'Pengumuman! Akan diadakan kegiatan Persami pada 21 Oktober 2024.',
      time: 'Kemarin',
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/684/684908.png',
      isRead: true,
    ),
  ];

  // --- DATA DUMMY: MANAJEMEN ---
  final List<NotifData> _listManajemen = [
    NotifData(
      id: 'mj1',
      type: 'persetujuan',
      title: 'Pengajuan Dana Ekstrakurikuler',
      description:
          'Terdapat pengajuan anggaran baru yang menunggu persetujuan Anda.',
      time: '2 min',
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/1682/1682308.png',
      isRead: false,
    ),
    NotifData(
      id: 'mj2',
      type: 'laporan',
      title: 'Laporan Keuangan Bulanan',
      description:
          'Laporan keuangan bulan September telah selesai dan siap di-review.',
      time: 'Kemarin',
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/3201/3201521.png',
      isRead: true,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Menangkap role dari argumen rute navigasi
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('role')) {
      _userRole = args['role'];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Memilih daftar data berdasarkan role
    final currentData = _userRole == 'manajemen'
        ? _listManajemen
        : _listOrangTua;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF31313E)),
          onPressed: () {
            if (_selectedNotif != null) {
              // Jika sedang melihat detail, kembali ke list
              setState(() => _selectedNotif = null);
            } else {
              // Keluar dari halaman
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFF3F4F6), height: 1.0),
        ),
      ),
      body: _selectedNotif == null
          ? _buildListView(currentData)
          : _buildDetailView(_selectedNotif!),
    );
  }

  // --- WIDGET LIST VIEW ---
  Widget _buildListView(List<NotifData> data) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada notifikasi.',
          style: TextStyle(fontFamily: 'Alexandria', color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
      itemBuilder: (context, index) {
        final item = data[index];

        return InkWell(
          onTap: () {
            setState(() {
              item.isRead = true; // Tandai sudah dibaca
              _selectedNotif = item; // Buka detail
            });
          },
          child: Container(
            color: item.isRead
                ? Colors.white
                : const Color(0xFFF8F9FE), // Biru sangat pudar jika unread
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationIcon(item),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                color: const Color(0xFF31313E),
                                fontWeight: item.isRead
                                    ? FontWeight.w600
                                    : FontWeight.bold,
                                fontSize: 14,
                                height: 1.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.time,
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              color: Colors.grey.shade500,
                              fontSize: 12,
                              fontWeight: item.isRead
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
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

  // --- WIDGET ICON BUILDER ---
  Widget _buildNotificationIcon(NotifData item) {
    if (item.type == 'tugas') {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            item.initials ?? '',
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
      return Container(
        width: 44,
        height: 44,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF9FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF3E8FF)),
        ),
        child: Image.network(
          item.iconUrl ?? '',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.notifications_active, color: Colors.grey),
        ),
      );
    }
  }

  // --- WIDGET DETAIL VIEW ---
  Widget _buildDetailView(NotifData item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildNotificationIcon(item),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.title,
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
            item.time,
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
            item.description,
            style: const TextStyle(
              fontFamily: 'Alexandria',
              color: Color(0xFF4B5563),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),

          // --- TOMBOL AKSI TAMBAHAN (Sesuai jenis) ---
          if (item.type == 'tugas')
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
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
          else if (item.type == 'pembayaran')
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () {},
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
