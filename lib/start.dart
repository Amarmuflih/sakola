import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 1. LOGO SAKOLA
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: SizedBox(
                width: 121,
                height: 28,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 2. TEXT HEADING
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: SizedBox(
                width: 364,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF31313E),
                      height: 1.2,
                      fontFamily: 'Poppins',
                    ),
                    children: [
                      TextSpan(text: 'Solusi Cerdas untuk\n'),
                      TextSpan(
                        text: 'Manajemen Sekolah\n',
                        style: TextStyle(color: Color(0xFF9155DF)),
                      ),
                      TextSpan(text: 'di Era Digital'),
                    ],
                  ),
                ),
              ),
            ),

            // 3. GAMBAR TENGAH (FULL WIDTH)
            Expanded(
              child: Container(
                width: double.infinity, // Memaksa container selebar layar
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: Image.asset(
                  'assets/images/start.png',
                  // fitWidth akan membuat gambar nempel ke pinggir kiri-kanan
                  // Jika ingin benar-benar penuh dan memotong sedikit atas/bawah agar pas, gunakan BoxFit.cover
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center,
                ),
              ),
            ),
            // 4. TOMBOL MULAI SEKARANG
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  // Menggunakan Container agar lebih aman dengan constraints
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    maxWidth: 364,
                  ), // Tambahkan const di sini
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      // Aksi navigasi
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF31313E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Mulai Sekarang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 5. FOOTER VERSI
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'versi 1.0.2-2024',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
