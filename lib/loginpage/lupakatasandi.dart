import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Variabel untuk switch tampilan
  bool _isEmailSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF31313E)),
          onPressed: () {
            if (_isEmailSent) {
              setState(() => _isEmailSent = false);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        titleSpacing: 0,
        title: const Text(
          'Kembali',
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 16,
            color: Color(0xFF31313E),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        // Switch antara halaman Input dan halaman Sukses
        child: _isEmailSent ? _buildSuccessState() : _buildInputState(),
      ),
    );
  }

  // --- TAMPILAN 1: FORM INPUT EMAIL ---
  Widget _buildInputState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'Lupa kata sandi',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF31313E),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Masukkan alamat email untuk menerima link reset kata sandi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 14,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          // Input Email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Email',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'ex: budi@sakola.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Tombol Kirim
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                setState(() => _isEmailSent = true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF31313E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Kirim',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAMPILAN 2: EMAIL TERKIRIM ---
  Widget _buildSuccessState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // Icon Illustration (Amplop Ungu)
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF9FF),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF3E8FF), width: 2),
              ),
              child: const Icon(
                Icons.mark_email_read_outlined,
                size: 64,
                color: Color(0xFF9155DF),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Email Terkirim!',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF31313E),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'link reset password sudah terkirim ke email Anda. Periksa email dan ikuti langkah-langkah untuk mengubah password.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 14,
              color: Colors.grey,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          // Tombol Cek Email
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                // Biasanya membuka aplikasi email
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF31313E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Cek Email',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
