import 'package:flutter/material.dart';

class Tagihan extends StatefulWidget {
  const Tagihan({Key? key}) : super(key: key);

  @override
  State<Tagihan> createState() => _TagihanState();
}

class _TagihanState extends State<Tagihan> {
  String _activeTab = 'Semua';
  Map<String, dynamic>? _selectedDetail;

  // DATA DUMMY
  final List<Map<String, dynamic>> _tagihanList = [
    {
      'id': 'spp_okt',
      'type': 'tagihan',
      'title': 'SPP Oktober 2024',
      'status': 'Belum dibayar',
      'amount': '345,000',
      'image': 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
      'dueDate': '31 Oktober 2024',
      'studentName': 'Asep Jumaedi',
      'studentClass': 'NIS: 31424 - Kelas 3D',
      'noTagihan': '#SPP001/10/102024',
    },
    {
      'id': 'kunjungan',
      'type': 'tagihan',
      'title': 'Kunjungan Industri',
      'status': 'Belum dibayar',
      'amount': '1,500,000',
      'image': 'https://cdn-icons-png.flaticon.com/512/744/744465.png',
      'dueDate': '31 Desember 2024',
      'studentName': 'Asep Jumaedi',
      'studentClass': 'NIS: 31424 - Kelas 3D',
      'noTagihan': '#KUNJ001/12/102024',
    },
    {
      'id': 'persami',
      'type': 'tagihan',
      'title': 'Event Persami',
      'status': 'Belum dibayar',
      'amount': '100,000',
      'image': 'https://cdn-icons-png.flaticon.com/512/684/684908.png',
      'dueDate': '21 Oktober 2024',
      'studentName': 'Asep Jumaedi',
      'studentClass': 'NIS: 31424 - Kelas 3D',
      'noTagihan': '#S001/10/102024',
      'infoPeserta': '100 Peserta',
      'infoTanggal': '21 Oktober 2024',
      'infoPemohon': 'Budi Jumaedi, Pembina',
      'deskripsi':
          'Acara Perkemahan Sabtu-Minggu (Persami) di lokasi lapangan sekolah.',
    },
  ];

  final List<Map<String, dynamic>> _riwayatList = [
    {
      'id': 'spp_sep',
      'type': 'riwayat',
      'title': 'SPP September 2024',
      'date': 'Sep 23, 2024',
      'amount': '345,000',
      'image': 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
    },
    {
      'id': 'seragam',
      'type': 'riwayat',
      'title': 'Seragam OSIS 1 pasang',
      'date': 'Sep 18, 2024',
      'amount': '78,000',
      'image': 'https://cdn-icons-png.flaticon.com/512/892/892458.png',
    },
    {
      'id': 'kaos_kaki',
      'type': 'riwayat',
      'title': 'Kaos kaki putih 3 pasang',
      'date': 'Agu 18, 2024',
      'amount': '30,000',
      'image': 'https://cdn-icons-png.flaticon.com/512/2589/2589903.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // KUNCI: Hilangkan tombol back HANYA jika sedang di tampilan List Utama
        automaticallyImplyLeading: _selectedDetail != null,
        title: Text(
          _selectedDetail != null ? 'Tagihan' : 'Tagihan dan Pembayaran',
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF31313E),
        leading: _selectedDetail != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedDetail = null),
              )
            : null,
      ),
      body: _selectedDetail != null ? _buildDetailView() : _buildListView(),
    );
  }

  Widget _buildListView() {
    return Column(
      children: [
        _buildTabNavigation(),
        _buildSummaryHeader(),
        Expanded(
          child: ListView(
            children: [
              if (_activeTab == 'Semua' || _activeTab == 'Tagihan') ...[
                _buildSectionTitle('Tagihan'),
                ..._tagihanList
                    .map((item) => _buildListItem(item, isTagihan: true))
                    .toList(),
              ],
              if (_activeTab == 'Semua' || _activeTab == 'Riwayat') ...[
                _buildSectionTitle('Riwayat Pembayaran'),
                ..._riwayatList
                    .map((item) => _buildListItem(item, isTagihan: false))
                    .toList(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // --- WIDGET TAB NAVIGATION BARU ---
  Widget _buildTabNavigation() {
    final tabs = ['Semua', 'Tagihan', 'Riwayat'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = _activeTab == tab;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeTab = tab),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(99),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF31313E)
                        : const Color(0xFF9CA3AF),
                    fontFamily: 'Alexandria',
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- WIDGET RINGKASAN TAGIHAN & NOMINAL BARU ---
  Widget _buildSummaryHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          // Bagian Kiri (3 Tagihan)
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long,
                  color: Color(0xFF7F3FBF),
                  size: 36,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '3 Tagihan',
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF31313E),
                      ),
                    ),
                    Text(
                      'Tagihan',
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Pemisah Garis Tengah
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          const SizedBox(width: 16),

          // Bagian Kanan (Nominal)
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  color: Color(0xFF7F3FBF),
                  size: 36,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Rp 2,398,000',
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF31313E),
                      ),
                    ),
                    Text(
                      'Nominal',
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Alexandria',
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildListItem(Map<String, dynamic> item, {required bool isTagihan}) {
    return InkWell(
      onTap: () {
        if (isTagihan) {
          setState(() => _selectedDetail = item);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Image.network(
                item['image'],
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported);
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isTagihan ? item['status'] : item['date'],
                    style: TextStyle(
                      color: isTagihan ? Colors.orange : Colors.grey.shade600,
                      fontFamily: 'Alexandria',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Rp ${item['amount']}',
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Image.network(
            _selectedDetail!['image'],
            height: 120,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image, size: 120);
            },
          ),

          const SizedBox(height: 24),

          Text(
            _selectedDetail!['title'],
            style: const TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Rp ${_selectedDetail!['amount']}',
            style: const TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9155DF),
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                ),

                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedDetail!['studentName'],
                      style: const TextStyle(
                        fontFamily: 'Alexandria',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _selectedDetail!['studentClass'],
                      style: const TextStyle(
                        fontFamily: 'Alexandria',
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/metode-pembayaran',
                  arguments: {
                    'id': _selectedDetail!['id'],
                    'title': _selectedDetail!['title'],
                    'amount': _selectedDetail!['amount'],
                    'studentName': _selectedDetail!['studentName'],
                    'studentClass': _selectedDetail!['studentClass'],
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF31313E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Bayar Sekarang',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  color: Colors.white,
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
