import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sakola/app/widgets/custom_inkwell_widget.dart';
import '../../../utils/storage_keys.dart';
import '../controllers/choose_company_controller.dart';

class ChooseCompanyView extends GetView<ChooseCompanyController> {
  const ChooseCompanyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ChooseCompanyController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, result) {
        if (didPop) return;
        controller.getBack();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () => logout(),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Pilih Perusahaan",
            style: TextStyle(
              color: Color(0xFF344054),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildUserInfo(controller), _buildCompanyList(controller)],
        ),
      ),
    );
  }

  Widget _buildUserInfo(ChooseCompanyController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              'Halo ${controller.name.value}',
              style: const TextStyle(
                color: Color(0xFF344054),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              'Anda Masuk Sebagai ${controller.email.value},\nSilakan pilih sekolah/perusahaan di bawah ini.',
              style: const TextStyle(
                color: Color(0xFF98A2B3),
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyList(ChooseCompanyController controller) {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF9155DF)),
          );
        }

        if (controller.companies.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.business_outlined,
                  size: 64,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tidak ada data perusahaan.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: controller.chooseCompanySC.value,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.companies.length,
          itemBuilder: (ctx, idx) => _buildCompanyItem(controller, idx),
        );
      }),
    );
  }

  Widget _buildCompanyItem(ChooseCompanyController controller, int idx) {
    final companyData = controller.companies[idx].company;

    // Fallback status & tanggal jika data API kosong
    final status = 'Trial';
    final endDate = '01 May 2026';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- BARIS 1: Nama Perusahaan dan Badge Status ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    companyData?.name ?? 'Nama Tidak Tersedia',
                    style: const TextStyle(
                      color: Color(0xFF101828),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF79009), // Warna Orange Trial
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE4E7EC)),

          // --- BARIS 2: Informasi Berakhir Pada ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Berakhir Pada',
                  style: TextStyle(
                    color: Color(0xFF344054),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  endDate,
                  style: const TextStyle(
                    color: Color(0xFF98A2B3),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE4E7EC)),

          // --- BARIS 3: Tombol Masuk Perusahaan ---
          // Diganti dari InkWell polos jadi CustomInkwellWidget. Efek
          // ripple/splash bawaan sengaja dimatiin karena sudah ada
          // visual feedback sendiri (background ungu pudar di dalamnya),
          // jadi gak dobel efek pas di-tap.
          CustomInkwellWidget(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            onTap: () {
              final box = GetStorage();
              box.write(
                StorageKeys.userCompany, // sebelumnya: 'user_company'
                jsonEncode(controller.companies[idx].toJson()),
              );
              controller.getDataUser();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF), // Latar ungu pudar
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Masuk Perusahaan',
                    style: TextStyle(
                      color: Color(0xFF9155DF), // Teks ungu Sakola
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
