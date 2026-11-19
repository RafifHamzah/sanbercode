import 'package:dio/dio.dart';

class NetworkFailure implements Exception {
  final String message;

  const NetworkFailure(this.message);

  @override
  String toString() => message;
}

class ErrorHandler {
  const ErrorHandler._();

  static NetworkFailure fromDioException(DioException exception) {
    final responseMessage = _responseMessage(exception.response?.data);
    if (responseMessage != null) {
      return NetworkFailure(responseMessage);
    }

    return switch (exception.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => const NetworkFailure(
        'Waktu koneksi habis. Periksa jaringan lalu coba lagi.',
      ),
      DioExceptionType.connectionError => const NetworkFailure(
        'Koneksi ke server terputus. Periksa internet Anda.',
      ),
      DioExceptionType.badResponse => NetworkFailure(
        'Server gagal memproses permintaan'
        '${exception.response?.statusCode == null ? '.' : ' (${exception.response!.statusCode}).'}',
      ),
      DioExceptionType.cancel => const NetworkFailure(
        'Permintaan dibatalkan.',
      ),
      DioExceptionType.badCertificate ||
      DioExceptionType.unknown => const NetworkFailure(
        'Tidak dapat terhubung ke server. Coba lagi nanti.',
      ),
    };
  }

  static String? _responseMessage(Object? data) {
    if (data is Map) {
      final message = data['message'] ?? data['error'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
    }
    return null;
  }
}
