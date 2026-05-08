import 'package:flutter/material.dart';

class Cctv extends StatefulWidget {
  const Cctv({Key? key}) : super(key: key);

  @override
  State<Cctv> createState() => _CctvState();
}

class _CctvState extends State<Cctv> {
  // --- STATE ---
  String _searchQuery = '';
  String _selectedCategory = 'Kelas 3'; // Default aktif sesuai gambar
  Map<String, dynamic>?
  _selectedClass; // Jika null = List, jika ada isi = Detail

  // Kategori Kelas
  final List<String> _categories = [
    'Kelas 1',
    'Kelas 2',
    'Kelas 3',
    'Kelas 4',
    'Kelas 5',
    'Kelas 6',
  ];

  // Data Dummy CCTV
  final List<Map<String, dynamic>> _cctvData = [
    {
      'id': '3d',
      'name': 'Kelas 3D',
      'category': 'Kelas 3',
      'image':
          'https://img.freepik.com/free-photo/empty-classroom-due-coronavirus-pandemic_1303-26330.jpg',
    },
    {
      'id': '3e',
      'name': 'Kelas 3E',
      'category': 'Kelas 3',
      'image':
          'https://img.freepik.com/free-photo/view-empty-classroom-with-desks-chairs_23-2150318534.jpg',
    },
    {
      'id': '3f',
      'name': 'Kelas 3F',
      'category': 'Kelas 3',
      'image':
          'https://img.freepik.com/free-photo/view-empty-classroom-with-desks-chairs_23-2150318552.jpg',
    },
    {
      'id': '1a',
      'name': 'Kelas 1A',
      'category': 'Kelas 1',
      'image':
          'https://img.freepik.com/free-photo/education-day-arrangement-table-with-copy-space_23-2148721266.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter data berdasarkan kategori dan pencarian
    final filteredData = _cctvData.where((item) {
      final matchesCategory = item['category'] == _selectedCategory;
      final matchesSearch = item['name'].toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF31313E)),
          onPressed: () {
            if (_selectedClass != null) {
              // Jika sedang di detail, kembali ke list
              setState(() => _selectedClass = null);
            } else {
              // Jika di list, keluar dari halaman
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _selectedClass != null
              ? 'CCTV ${_selectedClass!['name']}'
              : 'CCTV Kelas',
          style: const TextStyle(
            fontFamily: 'Alexandria',
            color: Color(0xFF31313E),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: _selectedClass == null
          ? _buildListView(filteredData)
          : _buildDetailView(),
    );
  }

  // ===========================================================================
  // 1. TAMPILAN LIST UTAMA
  // ===========================================================================
  Widget _buildListView(List<Map<String, dynamic>> filteredData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Cari kelas',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontFamily: 'Alexandria',
                fontSize: 14,
              ),
              suffixIcon: const Icon(Icons.search, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF9155DF)),
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Scroll Horizontal Kategori Kelas 1 - 6
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                      _searchQuery = ''; // Reset pencarian saat ganti tab
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF31313E)
                          : Colors.white,
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
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF31313E),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // List CCTV Card
        Expanded(
          child: filteredData.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada kelas ditemukan',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontFamily: 'Alexandria',
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    return _buildCctvCard(filteredData[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCctvCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => setState(() => _selectedClass = item),
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(item['image']),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // Gradient gelap agar teks putih terbaca jelas
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.2),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Indikator Live & Nama Kelas
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50), // Hijau Live
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              // Teks Lihat Kelas
              const Text(
                'Lihat Kelas',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 2. TAMPILAN DETAIL CCTV (VIDEO PLAYER MOCKUP)
  // ===========================================================================
  Widget _buildDetailView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            height: 300, // Ukuran lebih kotak seperti di screenshot
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(_selectedClass!['image']),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              // Gradient atas bawah untuk UI Player
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Row: Indicator & Title
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedClass!['name'],
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  // Bottom Row: Player Controls
                  Row(
                    children: [
                      const Icon(Icons.pause, color: Colors.white, size: 24),
                      const SizedBox(width: 12),

                      // Progress Bar Mockup
                      Expanded(
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              height: 3,
                              width: double.infinity,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            Container(
                              height: 3,
                              width: 150, // Simulasi durasi terputar
                              color: Colors.white,
                            ),
                            Positioned(
                              left: 145,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),
                      const Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
