import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                // Memaksa tinggi konten minimal setinggi layar
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        // --- KONTEN ATAS ---
                        const SizedBox(height: 50),
                        Center(
                          child: SizedBox(
                            width: 120.99,
                            height: 28,
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          'Selamat Datang 👋',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            color: Color(0xFF31313E),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Isi email dan kata sandi untuk masuk ke aplikasi Sakola.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Form Email & Password
                        _buildTextField(
                          label: 'Email',
                          hint: 'ex: budi@sakola.com',
                          icon: Icons.email_outlined,
                        ),

                        const SizedBox(height: 20),

                        _buildTextField(
                          label: 'Kata sandi',
                          hint: 'Masukkan kata sandi',
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),

                        const SizedBox(height: 32),

                        // Tombol Masuk
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/navigation');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF31313E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: const Text(
                            'Lupa kata sandi',
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              color: Color(0xFF9155DF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // --- SPACER ---
                        // Spacer ini akan mengambil semua sisa ruang kosong
                        // sehingga footer terdorong ke paling bawah.
                        const Spacer(),

                        // --- FOOTER BAWAH ---
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            'versi 1.0.2-2024',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'Alexandria',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget Helper untuk Textfield agar kode lebih bersih
  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: isPassword ? _obscureText : false,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                  )
                : null,
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
    );
  }
}
