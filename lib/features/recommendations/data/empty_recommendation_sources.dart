import '../domain/models/nearby_cafe.dart';
import '../domain/models/order_snapshot.dart';
import '../domain/models/weather_snapshot.dart';
import '../domain/repositories/recommendation_repositories.dart';

class EmptyWeatherRecommendationSource implements WeatherRecommendationSource {
  const EmptyWeatherRecommendationSource();

  @override
  Future<WeatherSnapshot?> currentWeather(GeoPoint location) async => null;
}

class EmptyOrderHistorySource implements OrderHistorySource {
  const EmptyOrderHistorySource();

  @override
  Future<List<OrderSnapshot>> completedOrders(String userId) async => const [];
}

class EmptyNearbyCoffeeSource implements NearbyCoffeeSource {
  const EmptyNearbyCoffeeSource();

  @override
  Future<List<NearbyCafe>> nearbyCafes(GeoPoint location) async => const [];
}
