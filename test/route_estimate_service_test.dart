import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:jembergo_mobile_app/services/route_estimate_service.dart';
import 'package:latlong2/latlong.dart';

void main() {
  const origin = LatLng(-8.2, 113.6);
  const destination = LatLng(-8.4, 113.5);

  test(
    'parses OSRM distance, adjusted duration, and route coordinates',
    () async {
      final service = RouteEstimateService(
        client: MockClient((request) async {
          expect(request.url.host, 'router.project-osrm.org');
          expect(request.url.path, contains('/route/v1/driving/'));
          return http.Response(
            jsonEncode({
              'code': 'Ok',
              'routes': [
                {
                  'distance': 12500,
                  'duration': 600,
                  'geometry': {
                    'coordinates': [
                      [113.6, -8.2],
                      [113.5, -8.4],
                    ],
                  },
                },
              ],
            }),
            200,
          );
        }),
      );
      addTearDown(service.close);

      final estimate = await service.estimate(
        origin: origin,
        destination: destination,
      );

      expect(estimate.distanceMeters, 12500);
      expect(estimate.durationSeconds, 810);
      expect(estimate.routePoints, const [origin, destination]);
    },
  );

  test('rejects responses without a route', () async {
    final service = RouteEstimateService(
      client: MockClient(
        (request) async =>
            http.Response(jsonEncode({'code': 'NoRoute', 'routes': []}), 200),
      ),
    );
    addTearDown(service.close);

    expect(
      () => service.estimate(origin: origin, destination: destination),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects incomplete route geometry', () async {
    final service = RouteEstimateService(
      client: MockClient(
        (request) async => http.Response(
          jsonEncode({
            'code': 'Ok',
            'routes': [
              {
                'distance': 100,
                'duration': 10,
                'geometry': {
                  'coordinates': [
                    [113.6, -8.2],
                  ],
                },
              },
            ],
          }),
          200,
        ),
      ),
    );
    addTearDown(service.close);

    expect(
      () => service.estimate(origin: origin, destination: destination),
      throwsA(isA<FormatException>()),
    );
  });
}
