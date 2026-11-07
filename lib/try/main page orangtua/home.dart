import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // State untuk Data Dinamis
  String selectedMonth = 'Oktober';
  int selectedWeek = 1;

  // Data dummy kehadiran (Bisa ditarik dari API/Database nantinya)
  final Map<int, List<Map<String, dynamic>>> attendanceData = {
    1: [
      {'day': '1', 'status': 'masuk'},
      {'day': '2', 'status': 'izin'},
      {'day': '3', 'status': 'masuk'},
      {'day': '4', 'status': 'masuk'},
      {'day': '5', 'status': 'alpha'},
      {'day': '6', 'status': 'masuk'},
      {'day': '7', 'status': 'masuk'},
    ],
    2: [
      {'day': '8', 'status': 'masuk'},
      {'day': '9', 'status': 'masuk'},
      {'day': '10', 'status': 'masuk'},
      {'day': '11', 'status': 'weekend'}, // Ditandai Merah
      {'day': '12', 'status': 'weekend'}, // Ditandai Merah
      {'day': '13', 'status': 'izin'},
      {'day': '14', 'status': 'masuk'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER UNGU (Sesuai rincian: height 247, radius 12)
            _buildHeader(),

            // 2. KARTU SALDO (Melayang)
            _buildWalletCard(),

            // 3. MENU GRID (Fungsional ke rute)
            _buildMenuGrid(),

            const SizedBox(height: 10),

            // 4. KARTU KEHADIRAN (Dinamis: Pekan & Bulan)
            _buildAttendanceSection(),

            const SizedBox(height: 10),

            // 5. PAPAN PENGUMUMAN
            _buildAnnouncementSection(),

            const SizedBox(
              height: 100,
            ), // Memberi ruang agar tidak terpotong Navbar
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 230,
      decoration: const BoxDecoration(
        color: Color(0xFF7F3FBF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Selamat datang,',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontFamily: 'Alexandria',
                        ),
                      ),
                      Text(
                        'Alfian Ramadhan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Alexandria',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Tombol Notifikasi
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/notifikasi'),
                child: Container(
                  padding: const EdgeInsets.all(8),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Tombol Tagihan (Berfungsi ke rute /tagihan)
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/tagihan'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4D2),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.wallet_outlined,
                    color: Color(0xFFD4A017),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ada 2 tagihan perlu dibayarkan',
                      style: TextStyle(
                        color: Color(0xFF31313E),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Color(0xFF31313E), size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    return Transform.translate(
      offset: const Offset(0, -35), // Disesuaikan agar lebih rapat ke atas
      child: Center(
        child: Container(
          // Sesuai rincian: width: 380, height: 89
          width: 380,
          height: 89,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          // Sesuai rincian padding: T:14, R:20, B:14, L:20
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            // Sesuai rincian: border-radius: 20px
            borderRadius: BorderRadius.circular(20),
            // Sesuai rincian: border-width: 1px
            border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Saldo uang saku',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontFamily: 'Alexandria',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Rp 25,000',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF31313E),
                      fontFamily: 'Alexandria',
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Jarak antar tombol (gap: 24px)
              _walletBtn(Icons.add, 'Top up', '/topup'),
              const SizedBox(width: 24),
              _walletBtn(Icons.history, 'History', '/history'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _walletBtn(IconData icon, String label, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF7F3FBF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _menuItem(Icons.analytics_outlined, 'Rekap Nilai', '/rekap-nilai'),
          _menuItem(Icons.calendar_month_outlined, 'Jadwal', '/jadwal'),
          _menuItem(Icons.assignment_outlined, 'Tugas', '/tugas'),
          _menuItem(Icons.videocam_outlined, 'CCTV', '/cctv'),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF7F3FBF), size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kehadiran Anak',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              // Dropdown Bulan
              DropdownButton<String>(
                value: selectedMonth,
                underline: const SizedBox(),
                icon: const Icon(Icons.expand_more, size: 18),
                items: ['Oktober', 'November', 'Desember']
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (val) => setState(() => selectedMonth = val!),
              ),
            ],
          ),
          const Text(
            '1-7 Oktober 2024',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),
          // Barisan Tanggal Dinamis
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: attendanceData[selectedWeek]!.map((data) {
              Color color;
              switch (data['status']) {
                case 'masuk':
                  color = Colors.green;
                  break;
                case 'izin':
                  color = Colors.orange;
                  break;
                case 'alpha':
                  color = const Color(0xFFE0E0FF);
                  break;
                case 'weekend':
                  color = Colors.red;
                  break;
                default:
                  color = Colors.grey;
              }
              return Container(
                width: 38,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  data['day'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Legend
          Row(
            children: [
              const Text(
                'Keterangan:',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const Spacer(),
              _legendItem(Colors.green, 'Masuk'),
              const SizedBox(width: 8),
              _legendItem(Colors.orange, 'Izin'),
              const SizedBox(width: 8),
              _legendItem(const Color(0xFFE0E0FF), 'Alpha', isAlpha: true),
            ],
          ),
          const Divider(height: 32),
          // Kontrol Pekan & Persentase
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '5 Hari - ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '80%',
                      style: TextStyle(
                        color: Color(0xFF7F3FBF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _pekanBtn(Icons.chevron_left, () {
                    if (selectedWeek > 1) setState(() => selectedWeek--);
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Pekan $selectedWeek',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  _pekanBtn(Icons.chevron_right, () {
                    if (selectedWeek < 2) setState(() => selectedWeek++);
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, {bool isAlpha = false}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isAlpha ? Colors.black54 : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _pekanBtn(IconData icon, VoidCallback tap) {
    return InkWell(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _buildAnnouncementSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Papan Pengumuman',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/all_announcements'),
                child: const Text(
                  'Lihat semua',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
          _announcementCard(
            'Kunjungan Industri dijadwalkan pada akhir tahun 20 Desember 2024',
            '5 min',
          ),
          const SizedBox(height: 12),
          _announcementCard(
            'Event Persami akan diselenggarakan pada 19-20 Oktober 2024',
            '2 Sep',
          ),
        ],
      ),
    );
  }

  Widget _announcementCard(String title, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF9FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.campaign_outlined,
              color: Color(0xFF7F3FBF),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}
