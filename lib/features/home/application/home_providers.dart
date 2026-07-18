import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../recommendations/domain/models/recommendation.dart';
import '../../recommendations/domain/models/weather_snapshot.dart';

final homeUserNameProvider = Provider<String?>((ref) => null);
final homeUserIdProvider = Provider<String>((ref) => 'guest');
final homeLocationProvider = Provider<GeoPoint?>((ref) => null);
final homeRewardsPointsProvider = Provider<int>((ref) => 0);

final homeRecommendationRequestProvider = Provider<RecommendationRequest>(
  (ref) => RecommendationRequest(
    userId: ref.watch(homeUserIdProvider),
    now: DateTime.now(),
    location: ref.watch(homeLocationProvider),
  ),
);
