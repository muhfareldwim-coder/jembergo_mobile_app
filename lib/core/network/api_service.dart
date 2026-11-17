import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jembergo_mobile_app/core/constants/app_constants.dart';

typedef AccessTokenProvider = Future<String?> Function();

class ApiException implements Exception {
  const ApiException({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  ApiService({
    http.Client? client,
    Uri? baseUri,
    this.accessTokenProvider,
    this.timeout = const Duration(seconds: 30),
  }) : _client = client ?? http.Client(),
       _baseUri = _normalizeBaseUri(baseUri ?? _configuredBaseUri());

  final http.Client _client;
  final Uri? _baseUri;
  final AccessTokenProvider? accessTokenProvider;
  final Duration timeout;

  void close() => _client.close();

  Future<Object?> get(
    String path, {
    Map<String, String> queryParameters = const {},
  }) {
    return _request('GET', path, queryParameters: queryParameters);
  }

  Future<Object?> post(
    String path, {
    Object? body,
    Map<String, String> queryParameters = const {},
  }) {
    return _request('POST', path, body: body, queryParameters: queryParameters);
  }

  Future<Object?> put(
    String path, {
    Object? body,
    Map<String, String> queryParameters = const {},
  }) {
    return _request('PUT', path, body: body, queryParameters: queryParameters);
  }

  Future<Object?> delete(
    String path, {
    Map<String, String> queryParameters = const {},
  }) {
    return _request('DELETE', path, queryParameters: queryParameters);
  }

  Future<Object?> _request(
    String method,
    String path, {
    Object? body,
    Map<String, String> queryParameters = const {},
  }) async {
    final request = http.Request(method, _buildUri(path, queryParameters))
      ..headers['Accept'] = 'application/json';

    if (body != null) {
      request
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode(body);
    }

    final token = await accessTokenProvider?.call();
    if (token != null && token.trim().isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final streamedResponse = await _client.send(request).timeout(timeout);
    final responseBody = await streamedResponse.stream.bytesToString().timeout(
      timeout,
    );
    final isSuccessful =
        streamedResponse.statusCode >= 200 && streamedResponse.statusCode < 300;

    Object? decodedBody;
    if (responseBody.isNotEmpty) {
      try {
        decodedBody = jsonDecode(responseBody);
      } on FormatException {
        if (isSuccessful) rethrow;
        decodedBody = responseBody;
      }
    }

    if (!isSuccessful) {
      throw ApiException(
        statusCode: streamedResponse.statusCode,
        message: _errorMessage(decodedBody, streamedResponse.statusCode),
      );
    }

    return decodedBody;
  }

  Uri _buildUri(String path, Map<String, String> queryParameters) {
    final baseUri = _baseUri;
    if (baseUri == null) {
      throw StateError(
        'API_BASE_URL belum diatur. Jalankan aplikasi dengan '
        '--dart-define=API_BASE_URL=https://alamat-api/',
      );
    }

    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    if (path.startsWith('//') || Uri.tryParse(path)?.hasScheme == true) {
      throw ArgumentError.value(path, 'path', 'Gunakan path relatif API.');
    }

    final uri = baseUri.resolve(normalizedPath);
    return queryParameters.isEmpty
        ? uri
        : uri.replace(queryParameters: queryParameters);
  }

  static Uri? _configuredBaseUri() {
    final value = AppConstants.apiBaseUrl.trim();
    if (value.isEmpty) return null;

    final uri = Uri.tryParse(value);
    if (uri == null) {
      throw ArgumentError.value(value, 'API_BASE_URL', 'URL tidak valid.');
    }
    return uri;
  }

  static Uri? _normalizeBaseUri(Uri? uri) {
    if (uri == null) return null;
    if (!uri.isAbsolute ||
        uri.host.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw ArgumentError.value(
        uri,
        'baseUri',
        'Gunakan URL dasar HTTP(S), tanpa kredensial, query, atau fragment.',
      );
    }

    final path = uri.path.endsWith('/') ? uri.path : '${uri.path}/';
    return uri.replace(path: path);
  }

  static String _errorMessage(Object? body, int statusCode) {
    if (body is Map<String, dynamic> && body['message'] is String) {
      return body['message'] as String;
    }
    if (body is String && body.trim().isNotEmpty) return body;
    return 'Permintaan gagal (HTTP $statusCode).';
  }
}
