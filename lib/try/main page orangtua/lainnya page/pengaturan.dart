import 'package:flutter/material.dart';

class Pengaturan extends StatefulWidget {
  const Pengaturan({Key? key}) : super(key: key);

  @override
  State<Pengaturan> createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  bool _tagihan = true;
  bool _pembayaran = true;
  bool _tugas = true;
  bool _kegiatan = true;
  bool _update = true;

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
          'Pengaturan',
          style: TextStyle(
            fontFamily: 'Alexandria',
            color: Color(0xFF31313E),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFFF9FAFB),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                'Notifikasi',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                  fontSize: 13,
                ),
              ),
            ),
            _buildSwitch(
              'Pengingat tagihan',
              'Notifikasi terkait tagihan yang belum dibayar.',
              _tagihan,
              (v) => setState(() => _tagihan = v),
            ),
            _buildSwitch(
              'Notifikasi pembayaran',
              'Kami akan mengirim notifikasi jika pembayaran tagihan berhasil.',
              _pembayaran,
              (v) => setState(() => _pembayaran = v),
            ),
            _buildSwitch(
              'Pemberitahuan tugas siswa',
              'Notifikasi jika ada tugas untuk anak didik Anda.',
              _tugas,
              (v) => setState(() => _tugas = v),
            ),
            _buildSwitch(
              'Pemberitahuan kegiatan sekolah',
              'Notifikasi jika ada event sekolah yang akan datang.',
              _kegiatan,
              (v) => setState(() => _kegiatan = v),
            ),
            _buildSwitch(
              'Update Aplikasi',
              'Pemberitahuan jika ada versi terbaru aplikasi.',
              _update,
              (v) => setState(() => _update = v),
              hideDivider: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(
    String title,
    String sub,
    bool val,
    ValueChanged<bool> onChange, {
    bool hideDivider = false,
  }) {
    return Column(
      children: [
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF31313E),
            ),
          ),
          subtitle: Text(
            sub,
            style: TextStyle(
              fontFamily: 'Alexandria',
              color: Colors.grey.shade600,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          value: val,
          onChanged: onChange,
          activeTrackColor: const Color(0xFF9155DF),
          activeColor: Colors.white,
        ),
        if (!hideDivider)
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
      ],
    );
  }
}
