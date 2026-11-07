import 'package:dio/dio.dart' as dio;
import 'package:sakola/services/dio.dart';

class ApiRepository {
  // Otomatis memanggil mesin Dio yang sudah di-setting URL Sakola
  final _dio = DioService.dio;

  // Map untuk menyimpan cancel tokens berdasarkan key/endpoint
  final Map<String, dio.CancelToken> _cancelTokens = {};

  // Helper method untuk get atau create cancel token
  dio.CancelToken _getCancelToken(String key) {
    // Cancel token sebelumnya jika ada
    _cancelTokens[key]?.cancel(
      "Request dibatalkan karena ada request baru untuk $key",
    );

    // Buat cancel token baru
    _cancelTokens[key] = dio.CancelToken();
    return _cancelTokens[key]!;
  }

  // --- HTTP METHODS ---

  // Method untuk GET request
  Future getData([
    String? endpoint,
    Map<String, dynamic>? queryParameters,
    String? cancelKey,
  ]) async {
    try {
      dio.CancelToken? cancelToken;
      if (cancelKey != null) cancelToken = _getCancelToken(cancelKey);

      final response = await _dio.get(
        endpoint ?? '',
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Method untuk POST request (JSON)
  Future postData([
    String? endpoint,
    Map<String, dynamic>? payload,
    dio.Options? options,
    Map<String, dynamic>? queryParameters,
    String? cancelKey,
  ]) async {
    try {
      dio.CancelToken? cancelToken;
      if (cancelKey != null) cancelToken = _getCancelToken(cancelKey);

      final response = await _dio.post(
        endpoint ?? '',
        data: payload,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Method untuk PUT request (JSON)
  Future putData([
    String? endpoint,
    Map<String, dynamic>? payload,
    dio.Options? options,
    Map<String, dynamic>? queryParameters,
    String? cancelKey,
  ]) async {
    try {
      dio.CancelToken? cancelToken;
      if (cancelKey != null) cancelToken = _getCancelToken(cancelKey);

      final response = await _dio.put(
        endpoint ?? '',
        data: payload,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Method untuk PATCH request (JSON)
  Future patchData([
    String? endpoint,
    Map<String, dynamic>? payload,
    dio.Options? options,
    Map<String, dynamic>? queryParameters,
    String? cancelKey,
  ]) async {
    try {
      dio.CancelToken? cancelToken;
      if (cancelKey != null) cancelToken = _getCancelToken(cancelKey);

      final response = await _dio.patch(
        endpoint ?? '',
        data: payload,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Method untuk DELETE request
  Future deleteData([
    String? endpoint,
    Map<String, dynamic>? payload,
    dio.Options? options,
    Map<String, dynamic>? queryParameters,
    String? cancelKey,
  ]) async {
    try {
      dio.CancelToken? cancelToken;
      if (cancelKey != null) cancelToken = _getCancelToken(cancelKey);

      final response = await _dio.delete(
        endpoint ?? '',
        data: payload,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // --- FORM DATA METHODS (Khusus untuk Upload File/Gambar) ---

  Future postFormData([
    String? endpoint,
    dio.FormData? formData,
    dio.Options? options,
    Map<String, dynamic>? queryParameters,
    String? cancelKey,
  ]) async {
    try {
      dio.CancelToken? cancelToken;
      if (cancelKey != null) cancelToken = _getCancelToken(cancelKey);

      final response = await _dio.post(
        endpoint ?? '',
        data: formData,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future putFormData([
    String? endpoint,
    dio.FormData? formData,
    dio.Options? options,
    Map<String, dynamic>? queryParameters,
    String? cancelKey,
  ]) async {
    try {
      dio.CancelToken? cancelToken;
      if (cancelKey != null) cancelToken = _getCancelToken(cancelKey);

      final response = await _dio.put(
        endpoint ?? '',
        data: formData,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future patchFormData([
    String? endpoint,
    dio.FormData? formData,
    dio.Options? options,
    Map<String, dynamic>? queryParameters,
    String? cancelKey,
  ]) async {
    try {
      dio.CancelToken? cancelToken;
      if (cancelKey != null) cancelToken = _getCancelToken(cancelKey);

      final response = await _dio.patch(
        endpoint ?? '',
        data: formData,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // --- CLEANUP METHODS ---

  // Method untuk cancel request berdasarkan key
  void cancelRequest(String key) {
    _cancelTokens[key]?.cancel("Request dibatalkan oleh user");
    _cancelTokens.remove(key);
  }

  // Method untuk cancel semua request
  void cancelAllRequests() {
    for (var token in _cancelTokens.values) {
      token.cancel("Semua request dibatalkan saat dispose");
    }
    _cancelTokens.clear();
  }

  // Panggil ini di fungsi onClose() pada Controller Anda
  void dispose() {
    cancelAllRequests();
  }
}
