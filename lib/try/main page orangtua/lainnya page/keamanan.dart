import 'package:flutter/material.dart';

class Keamanan extends StatefulWidget {
  const Keamanan({Key? key}) : super(key: key);

  @override
  State<Keamanan> createState() => _KeamananState();
}

class _KeamananState extends State<Keamanan> {
  bool _obscureOld = true;
  bool _obscureNew = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF31313E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Keamanan',
          style: TextStyle(
            fontFamily: 'Alexandria',
            color: Color(0xFF31313E),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Kata sandi'),
            _buildPasswordField(
              hint: '••••••••',
              isObscure: _obscureOld,
              onToggle: () => setState(() => _obscureOld = !_obscureOld),
            ),
            const SizedBox(height: 16),
            _buildLabel('Kata sandi Baru'),
            _buildPasswordField(
              hint: 'Masukkan kata sandi',
              isObscure: _obscureNew,
              onToggle: () => setState(() => _obscureNew = !_obscureNew),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(
        leftText: 'Ubah Kata Sandi',
        rightText: 'Batal',
        onLeftTap: () {},
        onRightTap: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Alexandria',
          color: Colors.grey.shade700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hint,
    required bool isObscure,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Colors.grey,
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.grey,
            size: 20,
          ),
          tooltip: isObscure
              ? 'Tampilkan kata sandi'
              : 'Sembunyikan kata sandi',
          onPressed: onToggle,
        ),
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
    );
  }

  Widget _buildActionButtons({
    required String leftText,
    required String rightText,
    required VoidCallback onLeftTap,
    required VoidCallback onRightTap,
  }) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onLeftTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF31313E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                child: Text(
                  leftText,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: onRightTap,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                child: Text(
                  rightText,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    color: Color(0xFF31313E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
