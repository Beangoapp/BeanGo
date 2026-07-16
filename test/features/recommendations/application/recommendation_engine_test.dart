import 'package:beango/features/recommendations/application/nearby_recommendation_service.dart';
import 'package:beango/features/recommendations/application/order_recommendation_service.dart';
import 'package:beango/features/recommendations/application/recommendation_engine.dart';
import 'package:beango/features/recommendations/application/time_recommendation_service.dart';
import 'package:beango/features/recommendations/application/weather_recommendation_service.dart';
import 'package:beango/features/recommendations/domain/models/coffee_option.dart';
import 'package:beango/features/recommendations/domain/models/nearby_cafe.dart';
import 'package:beango/features/recommendations/domain/models/order_snapshot.dart';
import 'package:beango/features/recommendations/domain/models/recommendation.dart';
import 'package:beango/features/recommendations/domain/models/weather_snapshot.dart';
import 'package:beango/features/recommendations/domain/repositories/recommendation_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const latte = CoffeeOption(
    id: 'latte',
    cafeId: 'cafe-a',
    name: 'Iced Latte',
    style: DrinkStyle.icedLatte,
    price: 22,
  );
  const espresso = CoffeeOption(
    id: 'espresso',
    cafeId: 'cafe-a',
    name: 'Espresso',
    style: DrinkStyle.espresso,
    price: 14,
  );

  test('time recommendations adapt to the day period', () {
    const service = TimeRecommendationService();
    expect(
      service.recommend(DateTime(2026, 7, 16, 8)).value,
      DrinkStyle.flatWhite,
    );
    expect(
      service.recommend(DateTime(2026, 7, 16, 13)).value,
      DrinkStyle.coldBrew,
    );
    expect(
      service.recommend(DateTime(2026, 7, 16, 21)).value,
      DrinkStyle.decaf,
    );
  });

  test('weather recommendations react to heat and rain', () {
    const service = WeatherRecommendationService();
    final hot = service.recommend(
      WeatherSnapshot(
        temperatureCelsius: 41,
        condition: WeatherCondition.clear,
        observedAt: DateTime(2026, 7, 16),
      ),
    );
    final rain = service.recommend(
      WeatherSnapshot(
        temperatureCelsius: 22,
        condition: WeatherCondition.rain,
        observedAt: DateTime(2026, 7, 16),
      ),
    );
    expect(hot?.value, DrinkStyle.icedLatte);
    expect(rain?.reason, RecommendationReason.rainyWeather);
  });

  test('favorite and order again use completed available history', () {
    const service = OrderRecommendationService();
    final now = DateTime(2026, 7, 16, 10);
    final orders = [
      OrderSnapshot(
        id: 'latest',
        orderedAt: now.subtract(const Duration(days: 1)),
        items: const [latte, espresso],
        total: 36,
      ),
      OrderSnapshot(
        id: 'older',
        orderedAt: now.subtract(const Duration(days: 5)),
        items: const [latte],
        total: 22,
      ),
    ];
    expect(service.favorite(orders)?.value.id, latte.id);
    expect(service.orderAgain(orders, now)?.value.id, 'latest');
  });

  test('nearby recommendation chooses the closest open available cafe', () {
    const service = NearbyRecommendationService();
    final result = service.recommend(const [
      NearbyCafe(
        id: 'far',
        name: 'Far',
        distanceMeters: 1200,
        estimatedPreparationMinutes: 4,
        menu: [latte],
      ),
      NearbyCafe(
        id: 'near',
        name: 'Near',
        distanceMeters: 300,
        estimatedPreparationMinutes: 8,
        menu: [espresso],
      ),
    ]);
    expect(result?.value.id, 'near');
  });

  test('engine prepares one bundle for Home consumers', () async {
    final now = DateTime(2026, 7, 16, 8);
    final engine = RecommendationEngine(
      weatherSource: _WeatherSource(now),
      orderHistorySource: _OrdersSource(now, latte),
      nearbyCoffeeSource: const _NearbySource(latte),
    );
    final bundle = await engine.recommendations(
      RecommendationRequest(
        userId: 'user-1',
        now: now,
        location: const GeoPoint(latitude: 25.28, longitude: 51.53),
      ),
    );

    expect(bundle.timeBased.value, DrinkStyle.flatWhite);
    expect(bundle.weatherBased?.value, DrinkStyle.icedLatte);
    expect(bundle.favorite?.value.id, latte.id);
    expect(bundle.nearby?.value.id, 'cafe-a');
    expect(bundle.orderAgain, isNotNull);
  });
}

class _WeatherSource implements WeatherRecommendationSource {
  const _WeatherSource(this.now);

  final DateTime now;

  @override
  Future<WeatherSnapshot?> currentWeather(GeoPoint location) async =>
      WeatherSnapshot(
        temperatureCelsius: 38,
        condition: WeatherCondition.clear,
        observedAt: now,
      );
}

class _OrdersSource implements OrderHistorySource {
  const _OrdersSource(this.now, this.option);

  final DateTime now;
  final CoffeeOption option;

  @override
  Future<List<OrderSnapshot>> completedOrders(String userId) async => [
    OrderSnapshot(
      id: 'order-1',
      orderedAt: now.subtract(const Duration(hours: 24)),
      items: [option],
      total: option.price,
    ),
  ];
}

class _NearbySource implements NearbyCoffeeSource {
  const _NearbySource(this.option);

  final CoffeeOption option;

  @override
  Future<List<NearbyCafe>> nearbyCafes(GeoPoint location) async => [
    NearbyCafe(
      id: 'cafe-a',
      name: 'Cafe A',
      distanceMeters: 250,
      estimatedPreparationMinutes: 5,
      menu: [option],
    ),
  ];
}
