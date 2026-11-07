import 'package:flutter/material.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  // State untuk menyimpan metode pembayaran yang dipilih
  String _selectedMethod = 'DANA'; // Default sesuai gambar

  // State untuk membuka/menutup accordion
  bool _isEwalletExpanded = true;
  bool _isBankExpanded = true;

  @override
  Widget build(BuildContext context) {
    // Tangkap argumen yang dikirim dari halaman Tagihan
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: const Color(
        0xFFF4F5F7,
      ), // Warna background abu-abu terang
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF31313E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pilih Metode Pembayaran',
          style: TextStyle(
            fontFamily: 'Alexandria',
            color: Color(0xFF31313E),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. KARTU INFO TAGIHAN & SISWA (Data Dinamis)
            _buildStudentInfoCard(args),
            const SizedBox(height: 16),

            // 2. KARTU E-WALLET
            _buildCategoryCard(
              title: 'E-Wallet',
              icon: Icons.account_balance_wallet_outlined,
              isExpanded: _isEwalletExpanded,
              onToggle: () =>
                  setState(() => _isEwalletExpanded = !_isEwalletExpanded),
              children: [
                _buildPaymentOption('Gopay', Icons.wallet, Colors.blue),
                _buildPaymentOption(
                  'OVO',
                  Icons.generating_tokens,
                  Colors.purple,
                ),
                _buildPaymentOption(
                  'DANA',
                  Icons.data_saver_on,
                  Colors.blueAccent,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3. KARTU BANK TRANSFER
            _buildCategoryCard(
              title: 'Bank Transfer',
              icon: Icons.account_balance_outlined,
              isExpanded: _isBankExpanded,
              onToggle: () =>
                  setState(() => _isBankExpanded = !_isBankExpanded),
              children: [
                _buildPaymentOption('BCA', Icons.credit_card, Colors.blue),
                _buildPaymentOption('BNI', Icons.credit_card, Colors.orange),
                _buildPaymentOption(
                  'Mandiri',
                  Icons.credit_card,
                  Colors.blue.shade800,
                ),
              ],
            ),
            const SizedBox(height: 40),

            // TOMBOL BAYAR (Opsional, ditambahkan agar metode yang dipilih bisa dikonfirmasi)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Aksi setelah memilih metode bayar, misalnya konfirmasi PIN/Password
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Memproses pembayaran dengan $_selectedMethod...',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF31313E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Bayar dengan $_selectedMethod',
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET KARTU INFO SISWA ---
  Widget _buildStudentInfoCard(Map<String, dynamic>? args) {
    // Ambil data dinamis dari argumen, jika null beri default value
    final title = args?['title'] ?? 'Detail Tagihan';
    final studentName = args?['studentName'] ?? 'Nama Siswa';
    final studentClass = args?['studentClass'] ?? 'Detail Kelas';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF31313E),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://i.pravatar.cc/150?img=11',
                      ), // Ganti sesuai asset kamu
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
                        studentName,
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(0xFF31313E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        studentClass,
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          color: Colors.grey.shade600,
                          fontSize: 12,
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

  // --- WIDGET KARTU KATEGORI (E-WALLET / BANK) ---
  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kategori (Bisa di-tap untuk collapse/expand)
          InkWell(
            onTap: onToggle,
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF31313E), size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF31313E),
                  ),
                ),
                const Spacer(),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),

          // List Item Pembayaran (Hanya muncul jika isExpanded == true)
          if (isExpanded) ...[const SizedBox(height: 16), ...children],
        ],
      ),
    );
  }

  // --- WIDGET ITEM METODE PEMBAYARAN ---
  Widget _buildPaymentOption(String name, IconData logoIcon, Color logoColor) {
    bool isSelected = _selectedMethod == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = name;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF3E8FF)
              : Colors.white, // Ungu muda jika dipilih
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF9155DF) : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Mock Logo
            Icon(logoIcon, color: logoColor, size: 28),
            const SizedBox(width: 16),

            // Nama Metode
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF31313E),
                ),
              ),
            ),

            // Custom Radio Button (Lingkaran)
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF9155DF)
                      : Colors.grey.shade300,
                  width: isSelected
                      ? 6
                      : 2, // Ketebalan border berubah saat dipilih
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
