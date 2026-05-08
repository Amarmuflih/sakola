import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // 1. Definisikan nama route sesuai yang ada di main.dart kamu
  final List<String> _routeNames = [
    '/home',
    '/tagihan',
    '/absensi',
    '/lainnya',
  ];

  // 2. Data Navigasi untuk Icon dan Label
  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home_rounded, 'label': 'Home'},
    {'icon': Icons.description_outlined, 'label': 'Tagihan'},
    {'icon': Icons.checklist_rtl_rounded, 'label': 'Absensi'},
    {'icon': Icons.more_horiz_rounded, 'label': 'Lainnya'},
  ];

  @override
  Widget build(BuildContext context) {
    // Mengambil konfigurasi routes dari context (MaterialApp)
    // final routes = Navigator.of(context).widget.pages.isEmpty
    //     ? (context.findAncestorWidgetOfExactType<MaterialApp>()?.routes)
    //     : null;

    // Fallback: Jika kamu ingin memanggil routes yang didefinisikan di main.dart
    final Map<String, WidgetBuilder> routeMap =
        ModalRoute.of(context)?.settings.name != null
        ? (context.findAncestorWidgetOfExactType<MaterialApp>()?.routes ?? {})
        : {};

    return Scaffold(
      backgroundColor: Colors.white,
      // body menggunakan IndexedStack untuk performa & menjaga state halaman
      body: IndexedStack(
        index: _selectedIndex,
        children: _routeNames.map((name) {
          // Memanggil widget berdasarkan nama route di main.dart
          if (routeMap.containsKey(name)) {
            return routeMap[name]!(context);
          }
          return Center(child: Text("Route $name tidak ditemukan"));
        }).toList(),
      ),

      // Bottom Navigation Bar yang responsif
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
            children: List.generate(_navItems.length, (index) {
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
                            _navItems[index]['icon'],
                            color: isSelected
                                ? const Color(0xFF7F3FBF)
                                : Colors.grey[500],
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Animasi Label Teks Alexandria
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
                        child: Text(_navItems[index]['label']),
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
