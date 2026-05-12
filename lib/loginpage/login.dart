import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _rememberMe = false;

  // Controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // Muat data saat aplikasi dibuka
  }

  // --- LOGIKA SHARED PREFERENCES ---

  // 1. Muat data email & password jika user pernah mencentang 'Ingat saya'
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('saved_email') ?? '';
      _passwordController.text = prefs.getString('saved_password') ?? '';
      _rememberMe = prefs.getBool('remember_me') ?? false;
    });
  }

  // 2. Simpan atau hapus data berdasarkan status checkbox saat login berhasil
  Future<void> _handleSaveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('saved_email', _emailController.text.trim());
      await prefs.setString('saved_password', _passwordController.text.trim());
      await prefs.setBool('remember_me', true);
    } else {
      // Jika tidak dicentang, bersihkan data yang tersimpan
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- PROSES LOGIN ---
  Future<void> _loginProses() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showError('Email dan kata sandi tidak boleh kosong.');
      return;
    }

    setState(() => _isLoading = true);

    // Simpan credentials jika 'Ingat saya' aktif
    await _handleSaveCredentials();

    // Simulasi delay jaringan
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    String email = _emailController.text.trim().toLowerCase();

    // Logika Bypass Role
    if (email == 'ortu' || email == 'orangtua@sakola.com') {
      Navigator.pushReplacementNamed(
        context,
        '/navigation',
        arguments: {'role': 'orang_tua'},
      );
    } else if (email == 'admin' || email == 'manajemen@sakola.com') {
      Navigator.pushReplacementNamed(
        context,
        '/navigation',
        arguments: {'role': 'manajemen'},
      );
    } else {
      _showError('Email salah! Gunakan "ortu" atau "admin".');
    }

    setState(() => _isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Alexandria'),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        // Logo Sakola
                        Center(
                          child: SizedBox(
                            width: 120,
                            height: 40,
                            child: Image.asset(
                              'assets/images/logo.png', // Pastikan asset ada
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.school,
                                    size: 40,
                                    color: Color(0xFF31313E),
                                  ),
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
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Field Email
                        _buildTextField(
                          label: 'Email',
                          hint: 'ex: ortu / admin',
                          icon: Icons.email_outlined,
                          controller: _emailController,
                        ),
                        const SizedBox(height: 20),

                        // Field Password
                        _buildTextField(
                          label: 'Kata sandi',
                          hint: 'Ketik apa saja bebas',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 16),

                        // Remember Me Checkbox
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                activeColor: const Color(0xFF9155DF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (val) =>
                                    setState(() => _rememberMe = val ?? false),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Ingat saya',
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                fontSize: 14,
                                color: Color(0xFF31313E),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Button Masuk
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _loginProses,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF31313E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Masuk',
                                    style: TextStyle(
                                      fontFamily: 'Alexandria',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/forgot-password'),
                          child: const Text(
                            'Lupa kata sandi',
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              color: Color(0xFF9155DF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
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

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _obscureText : false,
          style: const TextStyle(fontFamily: 'Alexandria', fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(icon, size: 20),
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
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF9155DF),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
