import '../domain/models/coffee_option.dart';
import '../domain/models/recommendation.dart';
import '../domain/models/weather_snapshot.dart';

class WeatherRecommendationService {
  const WeatherRecommendationService();

  Recommendation<DrinkStyle>? recommend(WeatherSnapshot? weather) {
    if (weather == null) return null;
    if (weather.condition == WeatherCondition.rain ||
        weather.condition == WeatherCondition.snow) {
      return const Recommendation(
        source: RecommendationSource.weather,
        reason: RecommendationReason.rainyWeather,
        value: DrinkStyle.flatWhite,
        score: .83,
      );
    }
    if (weather.temperatureCelsius >= 28) {
      return const Recommendation(
        source: RecommendationSource.weather,
        reason: RecommendationReason.hotWeather,
        value: DrinkStyle.icedLatte,
        score: .88,
      );
    }
    if (weather.temperatureCelsius <= 15) {
      return const Recommendation(
        source: RecommendationSource.weather,
        reason: RecommendationReason.coldWeather,
        value: DrinkStyle.flatWhite,
        score: .82,
      );
    }
    return null;
  }
}
