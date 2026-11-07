import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_inkwell_widget.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../controllers/navbar_controller.dart';

/// Shell utama app — nampung bottom navigation 4 tab: Home, Persetujuan,
/// Laporan, Lainnya. Isi tab-nya di-switch pakai `IndexedStack` (bukan
/// dibuat ulang tiap ganti tab) biar state tiap halaman (scroll position,
/// data yang udah di-fetch, dll) gak reset tiap kali pindah tab.
class NavbarView extends GetView<NavbarController> {
  const NavbarView({super.key});

  static const _purple = Color(0xFF7B61FF);
  static const _purpleLight = Color(0xFFF3F0FF);
  static const _grey = Color(0xFF98A2B3);
  static const _dark = Color(0xFF2D3748);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<NavbarController>()) {
      Get.put(NavbarController());
    }

    // FIX: sebelumnya list ini pakai `const [...]` — itu bikin error kalau
    // salah satu widget di dalamnya (DashboardHousingView) gak punya const
    // constructor. Sekarang list-nya sendiri gak const, tapi tiap ITEM di
    // dalamnya tetap dikasih `const` masing-masing (lebih aman & gak
    // maksa semuanya harus const-compatible sekaligus).
    //
    // TODO(user): ganti 3 placeholder di bawah ini (Persetujuan, Laporan,
    // Lainnya) begitu halaman aslinya udah dibuat — tinggal swap widget-nya
    // di list `pages` ini, gak perlu ubah bagian bottom nav sama sekali.
    final pages = [
      const DashboardView(),
      const _PlaceholderView(
        icon: Icons.task_alt_rounded,
        title: 'Persetujuan',
      ),
      const _PlaceholderView(icon: Icons.bar_chart_rounded, title: 'Laporan'),
      const _PlaceholderView(icon: Icons.more_horiz_rounded, title: 'Lainnya'),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(index: controller.indexPage.value, children: pages),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_rounded,
                  label: 'Home',
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.task_alt_rounded,
                  label: 'Persetujuan',
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.bar_chart_rounded,
                  label: 'Laporan',
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.more_horiz_rounded,
                  label: 'Lainnya',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isActive = controller.indexPage.value == index;

    return CustomInkwellWidget(
      onTap: () => controller.changePage(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? _purpleLight : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 22, color: isActive ? _purple : _grey),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? _dark : _grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder sementara buat tab yang halamannya belum dibuat. Ganti
/// widget ini di `pages` (di atas) begitu halaman aslinya siap.
class _PlaceholderView extends StatelessWidget {
  const _PlaceholderView({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'Halaman $title\nbelum dibuat',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
