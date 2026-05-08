import 'package:flutter/material.dart';

class MenuLainnya extends StatelessWidget {
  const MenuLainnya({Key? key}) : super(key: key);

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
            // --- SECTION: PROFIL SAYA ---
            _buildSectionHeader('Profil Saya'),
            _buildProfileItem(
              name: 'Alfian Ramadhan',
              subtitle: 'alfian.ramadhan@sakola.com',
              imageUrl:
                  'https://i.pravatar.cc/150?img=12', // Ganti dengan asset asli
            ),

            // --- SECTION: PROFIL ANAK ---
            _buildSectionHeader('Profil Anak'),
            _buildProfileItem(
              name: 'Asep Jumaedi',
              subtitle: 'NIS: 31424 • Kelas 3D',
              imageUrl:
                  'https://i.pravatar.cc/150?img=11', // Ganti dengan asset asli
              isChild: true, // Untuk layout gambar kotak rounded
            ),

            // --- SECTION: PENGATURAN ---
            _buildSectionHeader('Pengaturan'),
            _buildMenuItem(
              context: context,
              title: 'Akun saya',
              icon: Icons.person_outline,
              onTap: () {
                Navigator.pushNamed(context, '/akun-saya');
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              context: context,
              title: 'Pengaturan',
              icon: Icons.settings_outlined,
              onTap: () {
                Navigator.pushNamed(context, '/pengaturan');
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              context: context,
              title: 'Keamanan',
              icon: Icons.lock_outline,
              onTap: () {
                Navigator.pushNamed(context, '/keamanan');
              },
            ),

            // --- SECTION: LAINNYA ---
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
              title: 'Syarat dan ketentuan',
              icon: Icons.description_outlined,
              isExternal: true,
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              context: context,
              title: 'Kebijakan privasi',
              icon: Icons.privacy_tip_outlined,
              isExternal: true,
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              context: context,
              title: 'Keluar',
              icon: Icons.logout,
              isDestructive: true, // Merubah warna menjadi merah
              onTap: () {
                // Logika logout
              },
            ),

            const SizedBox(
              height: 40,
            ), // Spacer bawah agar tidak terpotong navbar
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9FAFB), // Background abu-abu terang
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
    // Penyesuaian warna jika tombol berupa aksi berbahaya (seperti Keluar)
    final Color mainColor = isDestructive
        ? const Color(0xFFE53935)
        : const Color(0xFF9155DF);
    final Color bgColor = isDestructive
        ? const Color(0xFFFFEBEE)
        : const Color(0xFFFBF9FF);
    final Color borderColor = isDestructive
        ? const Color(0xFFFFCDD2)
        : const Color(0xFFF3E8FF);
    final Color textColor = isDestructive
        ? const Color(0xFFE53935)
        : const Color(0xFF31313E);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            // Ikon dengan latar belakang desain custom (scalloped style simulation)
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
                  color: textColor,
                ),
              ),
            ),
            // Icon di kanan (Arrow biasa atau External Link)
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

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF3F4F6), // Garis pembatas tipis
    );
  }
}
