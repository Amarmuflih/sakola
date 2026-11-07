import 'package:flutter/material.dart';

// ============================================================================
// 1. HALAMAN UTAMA PERSETUJUAN (DESAIN SINKRON DENGAN TAGIHAN)
// ============================================================================
class Persetujuan extends StatefulWidget {
  const Persetujuan({Key? key}) : super(key: key);

  @override
  State<Persetujuan> createState() => _PersetujuanState();
}

class _PersetujuanState extends State<Persetujuan> {
  String _activeTab = 'Pending';

  final List<Map<String, dynamic>> _allRequests = [
    {
      'id': '1',
      'title': 'Anggaran Ekstrakurikuler',
      'type': 'Operasional',
      'date': '19 Oktober 2024',
      'status': 'Pending',
      'amount': 'Rp 5,000,000',
      'icon': Icons.account_balance_wallet_outlined,
      'iconColor': const Color(0xFF7F3FBF),
      'applicant': 'Siti Humaira, Koordinator',
      'submissionDate': '21 Oktober 2024',
      'desc':
          'Permintaan alokasi dana untuk kegiatan ekstrakurikuler basket sekolah.',
      'details': {
        'Pelatihan': 'Rp 2,500,000',
        'Seragam': 'Rp 1,000,000',
        'Peralatan': 'Rp 1,500,000',
      },
    },
    {
      'id': '2',
      'title': 'Pengadaan Buku',
      'type': 'Inventaris',
      'date': '19 Oktober 2024',
      'status': 'Pending',
      'amount': 'Rp 1,500,000',
      'icon': Icons.menu_book_outlined,
      'iconColor': const Color(0xFFF5A623),
      'applicant': 'Drs. Hanin Hamida S.pd',
      'submissionDate': '20 Oktober 2024',
      'desc': 'Pengadaan buku teks pelajaran Matematika untuk kelas 3.',
      'details': {
        'Buku Matematika': 'Rp 1,000,000',
        'Buku Latihan': 'Rp 500,000',
      },
    },
    {
      'id': '3',
      'title': 'Izin Acara Persami',
      'type': 'Event',
      'date': '19 Oktober 2024',
      'status': 'Pending',
      'amount': '-',
      'icon': Icons.event_available_outlined,
      'iconColor': const Color(0xFF4CAF50),
      'applicant': 'Budi Jumaedi, Pembina',
      'submissionDate': '21 Oktober 2024',
      'desc': 'Permintaan izin untuk mengadakan acara Persami.',
      'details': {'Perkiraan Peserta': '100 Peserta', 'Kegiatan': 'Pramuka'},
    },
    {
      'id': '4',
      'title': 'Pengadaan Barang: Kursi Guru',
      'type': 'Inventaris',
      'date': '5 Oktober 2024',
      'status': 'Disetujui',
      'amount': 'Rp 3,000,000',
      'icon': Icons.chair_alt_outlined,
      'iconColor': const Color(0xFFF5A623),
      'applicant': 'Tata Usaha',
      'submissionDate': 'Sep 23, 2024',
      'desc': 'Pengadaan 10 unit kursi baru untuk ruang guru.',
      'details': {'Kursi Kantor': 'Rp 3,000,000'},
    },
    {
      'id': '5',
      'title': 'Renovasi Laboratorium IPA',
      'type': 'Infrastruktur',
      'date': '5 Oktober 2024',
      'status': 'Disetujui',
      'amount': 'Rp 28,000,000',
      'icon': Icons.science_outlined,
      'iconColor': const Color(0xFF7F3FBF),
      'applicant': 'Kepala Sarpras',
      'submissionDate': 'Sep 18, 2024',
      'desc': 'Renovasi meja lab dan perbaikan saluran air.',
      'details': {'Material': 'Rp 20,000,000', 'Jasa': 'Rp 8,000,000'},
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredRequests = _activeTab == 'Semua'
        ? _allRequests
        : _allRequests.where((req) => req['status'] == _activeTab).toList();

    int count = filteredRequests.length;
    double totalNominal = 0;
    for (var req in filteredRequests) {
      if (req['amount'] != '-') {
        String numericString = req['amount'].replaceAll(RegExp(r'[^0-9]'), '');
        if (numericString.isNotEmpty)
          totalNominal += double.parse(numericString);
      }
    }

    String formattedNominal = totalNominal == 0
        ? "-"
        : "Rp ${totalNominal.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}";

    Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (var req in filteredRequests) {
      if (!groupedData.containsKey(req['date'])) groupedData[req['date']] = [];
      groupedData[req['date']]!.add(req);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Permintaan Persetujuan',
          style: TextStyle(
            fontFamily: 'Alexandria',
            color: Color(0xFF31313E),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTabNavigation(),
            _buildSummaryHeader(count, formattedNominal),
            Expanded(
              child: filteredRequests.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada permintaan',
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: groupedData.length,
                      itemBuilder: (context, index) {
                        String dateKey = groupedData.keys.elementAt(index);
                        List<Map<String, dynamic>> items =
                            groupedData[dateKey]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Tanggal Full Width
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              color: const Color(0xFFF8F9FD),
                              child: Text(
                                dateKey,
                                style: const TextStyle(
                                  fontFamily: 'Alexandria',
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            // List Item dengan Separator Full Width
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              separatorBuilder: (context, i) => Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              itemBuilder: (context, i) =>
                                  _buildListItem(items[i]),
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabNavigation() {
    final tabs = ['Semua', 'Pending', 'Disetujui'];
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
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryHeader(int totalItems, String totalNominal) {
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
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.assignment_outlined,
                  color: Color(0xFF7F3FBF),
                  size: 36,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$totalItems',
                      style: const TextStyle(
                        fontFamily: 'Alexandria',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF31313E),
                      ),
                    ),
                    const Text(
                      'Pending',
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
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  color: Color(0xFF7F3FBF),
                  size: 36,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        totalNominal,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF31313E),
                        ),
                      ),
                      const Text(
                        'Nominal',
                        style: TextStyle(
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
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(Map<String, dynamic> item) {
    bool isPending = item['status'] == 'Pending';
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPersetujuanScreen(data: item),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item['icon'], color: item['iconColor'], size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF31313E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (!isPending) ...[
                        Text(
                          "${item['submissionDate']}  •  ",
                          style: const TextStyle(
                            fontFamily: 'Alexandria',
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      Text(
                        item['status'],
                        style: TextStyle(
                          color: isPending
                              ? Colors.orange
                              : const Color(0xFF4CAF50),
                          fontFamily: 'Alexandria',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (item['amount'] != '-')
              Text(
                item['amount'],
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF31313E),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Catatan: Pastikan class DetailPersetujuanScreen tetap ada di bawah sini seperti kode kamu sebelumnya.
class DetailPersetujuanScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const DetailPersetujuanScreen({Key? key, required this.data})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ... (Gunakan kode DetailPersetujuanScreen yang sudah ada sebelumnya)
    return Scaffold(
      body: Center(child: Text("Halaman Detail ${data['title']}")),
    );
  }
}
