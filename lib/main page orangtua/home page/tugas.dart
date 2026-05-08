import 'package:flutter/material.dart';

class Tugas extends StatefulWidget {
  const Tugas({Key? key}) : super(key: key);

  @override
  State<Tugas> createState() => _TugasState();
}

class _TugasState extends State<Tugas> {
  // State Management
  Map<String, dynamic>? _selectedTask;
  String _searchQuery = '';
  String _selectedSubject = 'Semua pelajaran';

  // Opsi Dropdown
  final List<String> _subjects = [
    'Semua pelajaran',
    'Ilmu Pengetahuan Alam',
    'Bahasa Indonesia',
    'Matematika',
  ];

  // Data Dummy Tugas
  final List<Map<String, dynamic>> _tasks = [
    {
      'id': '1',
      'initials': 'LP',
      'color': const Color(0xFF7F3FBF), // Ungu
      'title': 'Laporan Percobaan IPA',
      'subject': 'Ilmu Pengetahuan Alam',
      'dueDate': '21 Oktober 2024',
      'status': 'Belum dikerjakan',
      'instructions':
          'Buat laporan dari percobaan perubahan wujud benda. Dari mencair, membeku, menguap hingga meleleh',
      'teacher': 'Drs. Hanin Hamida S.pd',
    },
    {
      'id': '2',
      'initials': 'TM',
      'color': const Color(0xFFE5B05C), // Oranye redup
      'title': 'Tugas Mengarang Cerita Pendek',
      'subject': 'Bahasa Indonesia',
      'dueDate': '25 Oktober 2024',
      'status': 'Sudah dikerjakan',
      'instructions':
          'Buatlah cerita pendek bertema pahlawan dengan minimal 3 halaman folio.',
      'teacher': 'Bpk. Ahmad Subarjo M.pd',
    },
    {
      'id': '3',
      'initials': 'TM',
      'color': const Color(0xFF7F3FBF), // Ungu
      'title': 'Tugas Mengarang Cerita Pendek',
      'subject': 'Bahasa Indonesia',
      'dueDate': '25 Oktober 2024',
      'status': 'Sudah dikerjakan',
      'instructions':
          'Buatlah cerita pendek bertema kebersihan lingkungan sekolah.',
      'teacher': 'Bpk. Ahmad Subarjo M.pd',
    },
    {
      'id': '4',
      'initials': 'SL',
      'color': const Color(0xFFE5B05C), // Oranye/Kuning
      'title': 'Soal Latihan Matematika Bab 3',
      'subject': 'Matematika',
      'dueDate': '26 Oktober 2024',
      'status': 'Belum dikerjakan',
      'instructions':
          'Kerjakan soal latihan matematika di buku paket halaman 45 nomor 1 sampai 10.',
      'teacher': 'Ibu Sri Wahyuni M.Si',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter logika untuk pencarian dan dropdown
    final filteredTasks = _tasks.where((task) {
      final matchesSearch = task['title'].toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesSubject =
          _selectedSubject == 'Semua pelajaran' ||
          task['subject'] == _selectedSubject;
      return matchesSearch && matchesSubject;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF31313E)),
          onPressed: () {
            if (_selectedTask != null) {
              setState(() => _selectedTask = null); // Kembali ke list
            } else {
              Navigator.pop(context); // Keluar dari halaman
            }
          },
        ),
        title: Text(
          _selectedTask != null ? 'Rincian Tugas' : 'Tugas',
          style: const TextStyle(
            fontFamily: 'Alexandria',
            color: Color(0xFF31313E),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _selectedTask == null
          ? _buildListView(filteredTasks)
          : _buildDetailView(),
    );
  }

  // ===========================================================================
  // 1. TAMPILAN DAFTAR TUGAS
  // ===========================================================================
  Widget _buildListView(List<Map<String, dynamic>> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Cari tugas',
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

        // Dropdown Filter Pelajaran
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSubject,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                items: _subjects.map((String subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(
                      subject,
                      style: const TextStyle(
                        fontFamily: 'Alexandria',
                        color: Color(0xFF31313E),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => _selectedSubject = newValue);
                  }
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // List Tugas
        Expanded(
          child: tasks.isEmpty
              ? Center(
                  child: Text(
                    'Tugas tidak ditemukan',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontFamily: 'Alexandria',
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: tasks.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF3F4F6),
                  ),
                  itemBuilder: (context, index) {
                    return _buildTaskItem(tasks[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task) {
    bool isDone = task['status'] == 'Sudah dikerjakan';
    Color statusColor = isDone
        ? const Color(0xFF4CAF50)
        : const Color(0xFFF5A623);

    return InkWell(
      onTap: () => setState(() => _selectedTask = task),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ikon Inisial
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: task['color'],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  task['initials'],
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Detail Tugas
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['title'],
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      color: Color(0xFF31313E),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task['subject'],
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Jatuh tempo: ${task['dueDate']}',
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Indikator Status
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        task['status'],
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          color: Color(0xFF31313E),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 2. TAMPILAN RINCIAN TUGAS
  // ===========================================================================
  Widget _buildDetailView() {
    bool isDone = _selectedTask!['status'] == 'Sudah dikerjakan';
    Color statusBgColor = isDone
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFF8E1);
    Color statusDotColor = isDone
        ? const Color(0xFF4CAF50)
        : const Color(0xFFF5A623);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Ikon & Judul
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _selectedTask!['color'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _selectedTask!['initials'],
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedTask!['title'],
                      style: const TextStyle(
                        fontFamily: 'Alexandria',
                        color: Color(0xFF31313E),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedTask!['subject'],
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

          const SizedBox(height: 24),

          // Status Tugas
          const Text(
            'Status Tugas',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF31313E),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusDotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedTask!['status'],
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    color: Color(0xFF31313E),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Instruksi Tugas
          const Text(
            'Intruksi Tugas',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF31313E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedTask!['instructions'],
            style: TextStyle(
              fontFamily: 'Alexandria',
              color: Colors.grey.shade600,
              fontSize: 14,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          // Dikumpulkan pada
          const Text(
            'Dikumpulkan pada',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF31313E),
            ),
          ),
          const SizedBox(height: 16),

          // Info Jatuh Tempo
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Jatuh tempo',
            value: _selectedTask!['dueDate'],
          ),
          const SizedBox(height: 16),

          // Info Nama Guru
          _buildInfoRow(
            icon: Icons.verified_user_outlined, // Badge check
            label: 'Nama Guru',
            value: _selectedTask!['teacher'],
          ),

          const SizedBox(height: 40),

          // Tombol Aksi
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                // Aksi tandai sudah dikerjakan
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF31313E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Sudah Dikerjakan',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () {
                // Aksi hubungi guru
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Color(0xFF31313E),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Hubungi Guru',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      color: Color(0xFF31313E),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk baris info (Jatuh tempo & Nama Guru)
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF9FF),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFF3E8FF), width: 1.5),
          ),
          child: Icon(icon, color: const Color(0xFF9155DF), size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                color: Color(0xFF31313E),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
