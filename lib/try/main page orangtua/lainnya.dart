import 'package:flutter/material.dart';

// 1. MODEL DATA NOTIFIKASI
class NotifItem {
  final String key;
  final String title;
  final String desc;
  final IconData icon;

  NotifItem({
    required this.key,
    required this.title,
    required this.desc,
    required this.icon,
  });
}

// ============================================================================
// 2. HALAMAN MENU LAINNYA
// ============================================================================
class MenuLainnya extends StatefulWidget {
  const MenuLainnya({Key? key}) : super(key: key);

  @override
  State<MenuLainnya> createState() => _MenuLainnyaState();
}

class _MenuLainnyaState extends State<MenuLainnya> {
  String _userRole = 'orang_tua'; // Default role

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('role')) {
      _userRole = args['role'];
    }
  }

  // --- FUNGSI DIALOG KELUAR (Sesuai Screenshot) ---
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Keluar',
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF31313E),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Apakah Anda yakin ingin keluar dari aplikasi?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFF05351,
                          ), // Warna merah screenshot
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Keluar',
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF31313E),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Menu Lainnya',
          style: TextStyle(
            fontFamily: 'Alexandria',
            color: Color(0xFF31313E),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Profil Saya'),
            _buildProfileItem(
              name: _userRole == 'manajemen'
                  ? 'Admin Manajemen'
                  : 'Alfian Ramadhan',
              subtitle: _userRole == 'manajemen'
                  ? 'admin@sakola.com'
                  : 'alfian.ramadhan@sakola.com',
              imageUrl: 'https://i.pravatar.cc/150?img=12',
            ),
            if (_userRole == 'orang_tua') ...[
              _buildSectionHeader('Profil Anak'),
              _buildProfileItem(
                name: 'Asep Jumaedi',
                subtitle: 'NIS: 31424 • Kelas 3D',
                imageUrl: 'https://i.pravatar.cc/150?img=11',
                isChild: true,
              ),
            ],
            _buildSectionHeader('Pengaturan'),
            _buildMenuItem(
              context: context,
              title: 'Akun saya',
              icon: Icons.person_outline,
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              context: context,
              title: 'Pengaturan',
              icon: Icons.settings_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PengaturanNotifikasiPage(),
                    settings: RouteSettings(arguments: {'role': _userRole}),
                  ),
                );
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              context: context,
              title: 'Keamanan',
              icon: Icons.lock_outline,
              onTap: () {},
            ),
            _buildSectionHeader('Lainnya'),
            _buildMenuItem(
              context: context,
              title: 'Hubungi kami',
              icon: Icons.chat_bubble_outline,
              isExternal: true,
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              context: context,
              title: 'Bantuan',
              icon: Icons.help_outline,
              isExternal: true,
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              context: context,
              title: 'Keluar',
              icon: Icons.logout,
              isDestructive: true,
              onTap: () => _showLogoutConfirmation(context),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS MENU ---
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9FAFB),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Alexandria',
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required String name,
    required String subtitle,
    required String imageUrl,
    bool isChild = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: isChild ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: isChild ? BorderRadius.circular(12) : null,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF31313E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isExternal = false,
    bool isDestructive = false,
  }) {
    final Color mainColor = isDestructive
        ? const Color(0xFFE53935)
        : const Color(0xFF9155DF);
    final Color bgColor = isDestructive
        ? const Color(0xFFFFEBEE)
        : const Color(0xFFFBF9FF);
    final Color borderColor = isDestructive
        ? const Color(0xFFFFCDD2)
        : const Color(0xFFF3E8FF);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: Icon(icon, color: mainColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: isDestructive ? mainColor : const Color(0xFF31313E),
                ),
              ),
            ),
            if (!isDestructive)
              Icon(
                isExternal ? Icons.open_in_new : Icons.chevron_right,
                color: Colors.grey.shade500,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() =>
      const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6));
}

// ============================================================================
// 3. HALAMAN PENGATURAN NOTIFIKASI (DESAIN CLEAN + ROLE)
// ============================================================================
class PengaturanNotifikasiPage extends StatefulWidget {
  const PengaturanNotifikasiPage({Key? key}) : super(key: key);

  @override
  State<PengaturanNotifikasiPage> createState() =>
      _PengaturanNotifikasiPageState();
}

class _PengaturanNotifikasiPageState extends State<PengaturanNotifikasiPage> {
  String _userRole = 'orang_tua';
  final Map<String, bool> _settingsValue = {};

  final List<NotifItem> _dataOrangTua = [
    NotifItem(
      key: 'tagihan',
      title: 'Pengingat tagihan',
      desc: 'Notifikasi terkait tagihan yang belum dibayar.',
      icon: Icons.notifications,
    ),
    NotifItem(
      key: 'pembayaran',
      title: 'Notifikasi pembayaran',
      desc: 'Kami akan mengirim notifikasi jika pembayaran berhasil.',
      icon: Icons.payment,
    ),
    NotifItem(
      key: 'tugas',
      title: 'Pemberitahuan tugas siswa',
      desc: 'Notifikasi jika ada tugas untuk anak didik Anda.',
      icon: Icons.assignment,
    ),
    NotifItem(
      key: 'kegiatan',
      title: 'Pemberitahuan kegiatan sekolah',
      desc: 'Notifikasi jika ada event sekolah yang akan datang.',
      icon: Icons.event,
    ),
    NotifItem(
      key: 'update',
      title: 'Update Aplikasi',
      desc: 'Pemberitahuan jika ada versi terbaru aplikasi.',
      icon: Icons.system_update,
    ),
  ];

  final List<NotifItem> _dataManajemen = [
    NotifItem(
      key: 'persetujuan',
      title: 'Permintaan persetujuan',
      desc: 'Notifikasi terkait permintaan persetujuan dari sekolah.',
      icon: Icons.check_circle,
    ),
    NotifItem(
      key: 'kegiatan_m',
      title: 'Pemberitahuan kegiatan sekolah',
      desc: 'Notifikasi jika ada event sekolah yang akan datang.',
      icon: Icons.event,
    ),
    NotifItem(
      key: 'laporan',
      title: 'Laporan keuangan bulanan',
      desc: 'Notifikasi jika laporan keuangan bulanan sudah diakses.',
      icon: Icons.analytics,
    ),
    NotifItem(
      key: 'siswa_baru',
      title: 'Pendaftaran siswa baru',
      desc: 'Notifikasi saat ada siswa baru yang mendaftar.',
      icon: Icons.person_add,
    ),
    NotifItem(
      key: 'keluar_masuk',
      title: 'Keluar/masuk siswa',
      desc: 'Pemberitahuan jika ada siswa yang keluar atau lulus.',
      icon: Icons.swap_horiz,
    ),
    NotifItem(
      key: 'update_m',
      title: 'Update Aplikasi',
      desc: 'Pemberitahuan jika ada versi terbaru aplikasi.',
      icon: Icons.system_update,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('role')) _userRole = args['role'];
    for (var item in [..._dataOrangTua, ..._dataManajemen])
      _settingsValue.putIfAbsent(item.key, () => true);
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _userRole == 'manajemen'
        ? _dataManajemen
        : _dataOrangTua;
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
          'Notifikasi',
          style: TextStyle(
            fontFamily: 'Alexandria',
            color: Color(0xFF31313E),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: currentData.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
        itemBuilder: (context, index) => _buildSwitchTile(currentData[index]),
      ),
    );
  }

  Widget _buildSwitchTile(NotifItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF31313E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.desc,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 13,
                    color: Color(0xFF9CA3AF),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: _settingsValue[item.key] ?? true,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF9155DF),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFE5E7EB),
              onChanged: (val) =>
                  setState(() => _settingsValue[item.key] = val),
            ),
          ),
        ],
      ),
    );
  }
}
