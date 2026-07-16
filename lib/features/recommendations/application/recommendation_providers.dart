import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/empty_recommendation_sources.dart';
import '../domain/models/recommendation.dart';
import '../domain/repositories/recommendation_repositories.dart';
import 'recommendation_engine.dart';

final weatherRecommendationSourceProvider =
    Provider<WeatherRecommendationSource>(
      (ref) => const EmptyWeatherRecommendationSource(),
    );

final orderHistorySourceProvider = Provider<OrderHistorySource>(
  (ref) => const EmptyOrderHistorySource(),
);

final nearbyCoffeeSourceProvider = Provider<NearbyCoffeeSource>(
  (ref) => const EmptyNearbyCoffeeSource(),
);

final recommendationEngineProvider = Provider<RecommendationEngine>(
  (ref) => RecommendationEngine(
    weatherSource: ref.watch(weatherRecommendationSourceProvider),
    orderHistorySource: ref.watch(orderHistorySourceProvider),
    nearbyCoffeeSource: ref.watch(nearbyCoffeeSourceProvider),
  ),
);

final homeRecommendationsProvider =
    FutureProvider.family<RecommendationBundle, RecommendationRequest>(
      (ref, request) =>
          ref.watch(recommendationEngineProvider).recommendations(request),
    );
