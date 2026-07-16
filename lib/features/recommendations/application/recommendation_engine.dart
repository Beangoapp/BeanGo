import '../domain/models/recommendation.dart';
import '../domain/models/nearby_cafe.dart';
import '../domain/repositories/recommendation_repositories.dart';
import 'nearby_recommendation_service.dart';
import 'order_recommendation_service.dart';
import 'time_recommendation_service.dart';
import 'weather_recommendation_service.dart';

class RecommendationEngine {
  const RecommendationEngine({
    required this.weatherSource,
    required this.orderHistorySource,
    required this.nearbyCoffeeSource,
    this.timeService = const TimeRecommendationService(),
    this.weatherService = const WeatherRecommendationService(),
    this.orderService = const OrderRecommendationService(),
    this.nearbyService = const NearbyRecommendationService(),
  });

  final WeatherRecommendationSource weatherSource;
  final OrderHistorySource orderHistorySource;
  final NearbyCoffeeSource nearbyCoffeeSource;
  final TimeRecommendationService timeService;
  final WeatherRecommendationService weatherService;
  final OrderRecommendationService orderService;
  final NearbyRecommendationService nearbyService;

  Future<RecommendationBundle> recommendations(
    RecommendationRequest request,
  ) async {
    final ordersFuture = orderHistorySource.completedOrders(request.userId);
    final weatherFuture = request.location == null
        ? Future.value()
        : weatherSource.currentWeather(request.location!);
    final nearbyFuture = request.location == null
        ? Future<List<NearbyCafe>>.value(const [])
        : nearbyCoffeeSource.nearbyCafes(request.location!);

    final orders = await ordersFuture;
    final weather = await weatherFuture;
    final nearbyCafes = await nearbyFuture;

    return RecommendationBundle(
      timeBased: timeService.recommend(request.now),
      weatherBased: weatherService.recommend(weather),
      favorite: orderService.favorite(orders),
      nearby: nearbyService.recommend(nearbyCafes),
      orderAgain: orderService.orderAgain(orders, request.now),
    );
  }
}
