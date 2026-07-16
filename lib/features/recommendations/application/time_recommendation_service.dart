import '../domain/models/coffee_option.dart';
import '../domain/models/recommendation.dart';

class TimeRecommendationService {
  const TimeRecommendationService();

  Recommendation<DrinkStyle> recommend(DateTime time) {
    final hour = time.hour;
    if (hour < 11) {
      return const Recommendation(
        source: RecommendationSource.time,
        reason: RecommendationReason.morningRoutine,
        value: DrinkStyle.flatWhite,
        score: .78,
      );
    }
    if (hour < 15) {
      return const Recommendation(
        source: RecommendationSource.time,
        reason: RecommendationReason.middayEnergy,
        value: DrinkStyle.coldBrew,
        score: .72,
      );
    }
    if (hour < 19) {
      return const Recommendation(
        source: RecommendationSource.time,
        reason: RecommendationReason.afternoonBoost,
        value: DrinkStyle.espresso,
        score: .68,
      );
    }
    return const Recommendation(
      source: RecommendationSource.time,
      reason: RecommendationReason.eveningChoice,
      value: DrinkStyle.decaf,
      score: .8,
    );
  }
}
