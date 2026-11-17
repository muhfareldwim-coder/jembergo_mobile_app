import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:jembergo_mobile_app/core/network/api_service.dart';

void main() {
  test(
    'sends JSON requests with the configured URL and access token',
    () async {
      final service = ApiService(
        baseUri: Uri.parse('https://api.example.test/v1'),
        client: MockClient((request) async {
          expect(request.method, 'POST');
          expect(
            request.url,
            Uri.https('api.example.test', '/v1/bookings', {'source': 'mobile'}),
          );
          expect(request.headers['Content-Type'], 'application/json');
          expect(request.headers['Authorization'], 'Bearer test-token');
          expect(jsonDecode(request.body), {'destinationId': 'papuma'});

          return http.Response(
            jsonEncode({'bookingId': 'booking-123'}),
            201,
            headers: {'content-type': 'application/json'},
          );
        }),
        accessTokenProvider: () async => 'test-token',
      );
      addTearDown(service.close);

      final response = await service.post(
        '/bookings',
        body: {'destinationId': 'papuma'},
        queryParameters: {'source': 'mobile'},
      );

      expect(response, {'bookingId': 'booking-123'});
    },
  );

  test('exposes API error status and message', () async {
    final service = ApiService(
      baseUri: Uri.parse('https://api.example.test/'),
      client: MockClient(
        (request) async => http.Response(
          jsonEncode({'message': 'Data tidak valid'}),
          422,
          headers: {'content-type': 'application/json'},
        ),
      ),
    );
    addTearDown(service.close);

    await expectLater(
      service.post('/bookings', body: const {}),
      throwsA(
        isA<ApiException>()
            .having((error) => error.statusCode, 'statusCode', 422)
            .having((error) => error.message, 'message', 'Data tidak valid'),
      ),
    );
  });
}
