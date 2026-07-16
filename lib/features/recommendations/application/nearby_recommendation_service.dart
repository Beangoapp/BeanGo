import '../domain/models/nearby_cafe.dart';
import '../domain/models/recommendation.dart';

class NearbyRecommendationService {
  const NearbyRecommendationService({this.maximumDistanceMeters = 5000});

  final int maximumDistanceMeters;

  Recommendation<NearbyCafe>? recommend(List<NearbyCafe> cafes) {
    final eligible =
        cafes
            .where(
              (cafe) =>
                  cafe.isOpen &&
                  cafe.distanceMeters <= maximumDistanceMeters &&
                  cafe.availableMenu.isNotEmpty,
            )
            .toList()
          ..sort((a, b) {
            final distance = a.distanceMeters.compareTo(b.distanceMeters);
            return distance != 0
                ? distance
                : a.estimatedPreparationMinutes.compareTo(
                    b.estimatedPreparationMinutes,
                  );
          });
    if (eligible.isEmpty) return null;
    return Recommendation(
      source: RecommendationSource.nearby,
      reason: RecommendationReason.closestOpenCafe,
      value: eligible.first,
      score: .84,
    );
  }
}
