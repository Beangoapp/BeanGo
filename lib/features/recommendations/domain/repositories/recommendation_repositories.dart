import '../models/nearby_cafe.dart';
import '../models/order_snapshot.dart';
import '../models/weather_snapshot.dart';

abstract interface class WeatherRecommendationSource {
  Future<WeatherSnapshot?> currentWeather(GeoPoint location);
}

abstract interface class OrderHistorySource {
  Future<List<OrderSnapshot>> completedOrders(String userId);
}

abstract interface class NearbyCoffeeSource {
  Future<List<NearbyCafe>> nearbyCafes(GeoPoint location);
}
