import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' as get_x;
import 'package:get_storage/get_storage.dart';
import 'package:sakola/app/routes/app_pages.dart';

class DioService {
  static Dio? _dio;

  static Dio get dio {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: dotenv.env['BASE_URL_API']!,
          headers: {'Accept': 'application/json'},
          contentType: 'application/json',
        ),
      );

      // Tambahkan interceptor untuk handling error dan token
      _dio!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final box = GetStorage();

            if (options.path.contains('conf.json')) {
              options.baseUrl = 'https://mandep.id/';
            }

            var getStorageUser = box.read('user_company');
            var token = box.read('token');

            // PERBAIKAN: Ambil company-id dari GetStorage tanpa
            // membutuhkan model authentication_model.dart.
            // 'user_company' diasumsikan menyimpan JSON String hasil
            // jsonEncode(...) dari object company yang dipilih user
            // di halaman /choose-company, contoh:
            // { "id": "...", "company_id": "...", ... }
            if (getStorageUser != null) {
              try {
                final dynamic decoded = getStorageUser is String
                    ? jsonDecode(getStorageUser)
                    : getStorageUser;

                // Coba beberapa kemungkinan nama field company id,
                // sesuaikan jika struktur penyimpanan kamu berbeda.
                final dynamic companyId = decoded is Map
                    ? (decoded['company_id'] ??
                          decoded['id'] ??
                          decoded['company']?['id'])
                    : null;

                if (companyId != null) {
                  options.headers['company-id'] = companyId.toString();
                }
              } catch (e) {
                get_x.Get.log(
                  "GAGAL PARSING user_company UNTUK company-id HEADER ::\n$e",
                );
              }
            }

            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
              options.connectTimeout = const Duration(milliseconds: 60 * 1000);
              options.receiveTimeout = const Duration(milliseconds: 60 * 1000);
            }

            // PERBAIKAN: Penanganan tipe data payload untuk mencegah error
            String payloadLog = '';
            if (options.data != null) {
              if (options.data is FormData) {
                payloadLog = (options.data as FormData).fields
                    .map((elData) => "${elData.key}:${elData.value}")
                    .join('\n');
              } else {
                payloadLog = options.data.toString();
              }
            }

            get_x.Get.log(
              "ON REQUEST ::\n\nURI =>\n${options.baseUrl}${options.path}\n\nMETHOD =>\n${options.method}\n\nHEADERS =>\n${options.headers}\n\nQUERY PARAMETER =>\n${options.queryParameters}\n\nPAYLOAD =>\n${options.method == 'POST' ? payloadLog : ''}",
            );

            return handler.next(options);
          },
          onResponse: (response, handler) {
            get_x.Get.log(
              "ON RESPONSE ::\n\nURI =>\n${response.requestOptions.uri}\n\nRESPONSE =>\n${jsonEncode(response.data)}",
            );
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            get_x.Get.log(
              "ON ERROR ::\n\nURI =>\n${e.requestOptions.uri}\n\nERROR =>\n${e.error}\n\nMESSAGE =>\n${e.message}\n\nSTATUS CODE =>\n${e.response?.statusCode}\n\nSTATUS MESSAGE =>\n${e.response?.statusMessage}\n\nRESPONSE DATA =>\n${e.response?.data}\n\nSTACKTRACE =>\n${e.stackTrace}",
            );

            _handleError(e);
            return handler.next(e);
          },
        ),
      );
    }
    return _dio!;
  }

  static void _handleError(DioException e) {
    String title = 'Error';
    String message = '';
    bool shouldShowError = true;

    // 1. DEKLARASI VARIABELNYA DI SINI (Ini yang bikin garis merah hilang)
    bool shouldShowDebugInfo = true;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Koneksi timeout, silakan coba lagi';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Gagal mengirim request, silakan coba lagi';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Server tidak merespon, silakan coba lagi';
        break;
      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 400:
          case 401:
            title = e.response?.data['status'] ?? 'Error';
            message = e.response?.data['message'] ?? 'Bad Request';

            // 2. MATIKAN BOTTOM SHEET DEBUG UNTUK ERROR LOGIN
            shouldShowDebugInfo = false;

            final isLoginRequest = e.requestOptions.path.contains('login');

            if (isLoginRequest) {
              // 3. Matikan Snackbar Dio khusus endpoint login
              shouldShowError = false;
            }

            if (e.response?.statusCode == 401 && !isLoginRequest) {
              // 4. Force logout hanya kalau bukan dari halaman login
              final box = GetStorage();
              box.remove('user_company');
              box.remove('token');
              box.remove('user');

              get_x.Get.offAllNamed(Routes.SIGN_IN);
            }
            break;
          case 403:
            message = 'Forbidden, Anda tidak memiliki akses';
            break;
          case 404:
            message = 'Data tidak ditemukan';
            break;
          case 500:
            message = 'Server Error, silakan coba lagi nanti';
            break;
          default:
            message = 'Terjadi kesalahan, silakan coba lagi';
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request dibatalkan';
        shouldShowError = false;
        shouldShowDebugInfo = false;
        break;
      default:
        message = 'Terjadi kesalahan, periksa koneksi internet Anda';
    }

    if (shouldShowError) {
      get_x.Get.snackbar(
        title,
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    // 5. PASTIKAN SYARAT INI MEMAKAI VARIABEL BARU
    if (kDebugMode && shouldShowDebugInfo) {
      get_x.Get.bottomSheet(
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          margin: EdgeInsets.only(top: get_x.Get.mediaQuery.viewPadding.top),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Debug Error Info',
                    style: get_x.Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => get_x.Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      _buildDebugRow('URL', e.requestOptions.uri.toString()),
                      _buildDebugRow('Method', e.requestOptions.method),
                      _buildDebugRow(
                        'Status Code',
                        e.response?.statusCode?.toString() ?? 'N/A',
                      ),
                      _buildDebugRow('Error Type', e.type.toString()),
                      _buildDebugRow('Error Message', e.message ?? 'N/A'),
                      if (e.requestOptions.headers.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Headers:',
                          style: get_x.Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(jsonEncode(e.requestOptions.headers)),
                      ],
                      if (e.requestOptions.data != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Request Data:',
                          style: get_x.Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          e.requestOptions.data is FormData
                              ? e.requestOptions.data.toString()
                              : jsonEncode(e.requestOptions.data),
                        ),
                      ],
                      if (e.response?.data != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Response Data:',
                          style: get_x.Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(jsonEncode(e.response?.data)),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
      );
    }
  }

  static Widget _buildDebugRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: get_x.Get.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}
