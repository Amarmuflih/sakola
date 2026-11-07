import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  String _userRole = 'orang_tua'; // Default role

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Menangkap argumen 'role' yang dikirim dari LoginScreen
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('role')) {
      _userRole = args['role'];
    }
  }

  // 1. Data Navigasi & Rute untuk ORANG TUA
  final List<String> _routesOrangTua = [
    '/home',
    '/tagihan',
    '/absensi',
    '/lainnya',
  ];

  final List<Map<String, dynamic>> _navOrangTua = [
    {'icon': Icons.home_rounded, 'label': 'Home'},
    {'icon': Icons.description_outlined, 'label': 'Tagihan'},
    {'icon': Icons.checklist_rtl_rounded, 'label': 'Absensi'},
    {'icon': Icons.more_horiz_rounded, 'label': 'Lainnya'},
  ];

  // 2. Data Navigasi & Rute untuk MANAJEMEN
  final List<String> _routesManajemen = [
    '/home_manajemen',
    '/persetujuan_manajemen',
    '/laporan_manajemen',
    '/lainnya', // Bisa disamakan atau dipisah dengan lainnya ortu
  ];

  final List<Map<String, dynamic>> _navManajemen = [
    {'icon': Icons.home_rounded, 'label': 'Home'},
    {'icon': Icons.assignment_turned_in_outlined, 'label': 'Persetujuan'},
    {'icon': Icons.bar_chart_rounded, 'label': 'Laporan'},
    {'icon': Icons.more_horiz_rounded, 'label': 'Lainnya'},
  ];

  @override
  Widget build(BuildContext context) {
    // Menentukan rute dan menu mana yang dipakai berdasarkan role
    final List<String> currentRoutes = _userRole == 'manajemen'
        ? _routesManajemen
        : _routesOrangTua;

    final List<Map<String, dynamic>> currentNavItems = _userRole == 'manajemen'
        ? _navManajemen
        : _navOrangTua;

    // Mengambil rute dari main.dart
    final Map<String, WidgetBuilder> routeMap =
        ModalRoute.of(context)?.settings.name != null
        ? (context.findAncestorWidgetOfExactType<MaterialApp>()?.routes ?? {})
        : {};

    return Scaffold(
      backgroundColor: Colors.white,
      // body menggunakan IndexedStack untuk performa & menjaga state halaman
      body: IndexedStack(
        index: _selectedIndex,
        children: currentRoutes.map((name) {
          // Memanggil widget berdasarkan nama route di main.dart
          if (routeMap.containsKey(name)) {
            return routeMap[name]!(context);
          }
          // Jika rute belum dibuat di main.dart, tampilkan pesan error ini
          return Center(
            child: Text(
              "Route $name belum didaftarkan di main.dart",
              style: const TextStyle(fontFamily: 'Alexandria', fontSize: 16),
            ),
          );
        }).toList(),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(currentNavItems.length, (index) {
              bool isSelected = _selectedIndex == index;

              return Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animasi Pill Background Ungu
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF7F3FBF).withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 250),
                          scale: isSelected ? 1.1 : 1.0,
                          child: Icon(
                            currentNavItems[index]['icon'],
                            color: isSelected
                                ? const Color(0xFF7F3FBF)
                                : Colors.grey[500],
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Animasi Label Teks
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isSelected
                              ? const Color(0xFF31313E)
                              : Colors.grey[500],
                        ),
                        child: Text(currentNavItems[index]['label']),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
