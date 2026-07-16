import 'coffee_option.dart';
import 'nearby_cafe.dart';
import 'order_snapshot.dart';
import 'weather_snapshot.dart';

enum RecommendationSource { time, weather, favorite, nearby, orderAgain }

enum RecommendationReason {
  morningRoutine,
  middayEnergy,
  afternoonBoost,
  eveningChoice,
  hotWeather,
  coldWeather,
  rainyWeather,
  frequentChoice,
  closestOpenCafe,
  recentOrder,
}

class Recommendation<T> {
  const Recommendation({
    required this.source,
    required this.reason,
    required this.value,
    required this.score,
  }) : assert(score >= 0 && score <= 1);

  final RecommendationSource source;
  final RecommendationReason reason;
  final T value;
  final double score;
}

class RecommendationBundle {
  const RecommendationBundle({
    required this.timeBased,
    this.weatherBased,
    this.favorite,
    this.nearby,
    this.orderAgain,
  });

  final Recommendation<DrinkStyle> timeBased;
  final Recommendation<DrinkStyle>? weatherBased;
  final Recommendation<CoffeeOption>? favorite;
  final Recommendation<NearbyCafe>? nearby;
  final Recommendation<OrderSnapshot>? orderAgain;
}

class RecommendationRequest {
  const RecommendationRequest({
    required this.userId,
    required this.now,
    this.location,
  });

  final String userId;
  final DateTime now;
  final GeoPoint? location;
}
