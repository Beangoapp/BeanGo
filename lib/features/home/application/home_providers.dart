import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/presentation/controllers/authentication_controller.dart';
import '../data/repositories/mock_home_repository.dart';
import '../domain/entities/home_content.dart';
import '../domain/repositories/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => const MockHomeRepository(),
);

final homeFeedProvider =
    AsyncNotifierProvider<HomeFeedController, HomeFeedState>(
      HomeFeedController.new,
    );

final homeUserNameProvider = Provider<String?>((ref) {
  return ref.watch(
    authenticationControllerProvider.select(
      (state) => state.session?.user.fullName,
    ),
  );
});

final homeSearchQueryProvider = NotifierProvider<HomeSearchQuery, String>(
  HomeSearchQuery.new,
);

final homeLocationIndexProvider = NotifierProvider<HomeLocationIndex, int>(
  HomeLocationIndex.new,
);

final homeCartProvider = NotifierProvider<HomeCartController, Map<String, int>>(
  HomeCartController.new,
);

class HomeCartController extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() => const {};

  void add(HomeProduct product) {
    final quantity = state[product.id] ?? 0;
    state = Map.unmodifiable({...state, product.id: quantity + 1});
  }
}

class HomeLocationIndex extends Notifier<int> {
  @override
  int build() => 0;

  void select(int index) => state = index.clamp(0, 2);
}

class HomeSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) => state = value.trim();
  void clear() => state = '';
}

class HomeFeedState {
  const HomeFeedState({
    required this.promotions,
    required this.categories,
    required this.nearbyCafes,
    required this.featuredCafes,
    required this.trendingDrinks,
    required this.recentOrders,
    required this.recommendedProducts,
    required this.nextPage,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  factory HomeFeedState.fromPage(HomePage page) => HomeFeedState(
    promotions: page.promotions,
    categories: page.categories,
    nearbyCafes: page.nearbyCafes,
    featuredCafes: page.featuredCafes,
    trendingDrinks: page.trendingDrinks,
    recentOrders: page.recentOrders,
    recommendedProducts: page.recommendedProducts,
    nextPage: page.page + 1,
    hasMore: page.hasMore,
  );

  final List<HomePromotion> promotions;
  final List<HomeCategory> categories;
  final List<HomeCafe> nearbyCafes;
  final List<HomeCafe> featuredCafes;
  final List<HomeProduct> trendingDrinks;
  final List<HomeRecentOrder> recentOrders;
  final List<HomeProduct> recommendedProducts;
  final int nextPage;
  final bool hasMore;
  final bool isLoadingMore;

  bool get isEmpty =>
      promotions.isEmpty &&
      nearbyCafes.isEmpty &&
      featuredCafes.isEmpty &&
      trendingDrinks.isEmpty &&
      recommendedProducts.isEmpty;

  HomeFeedState copyWith({
    List<HomeCafe>? nearbyCafes,
    List<HomeCafe>? featuredCafes,
    int? nextPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) => HomeFeedState(
    promotions: promotions,
    categories: categories,
    nearbyCafes: nearbyCafes ?? this.nearbyCafes,
    featuredCafes: featuredCafes ?? this.featuredCafes,
    trendingDrinks: trendingDrinks,
    recentOrders: recentOrders,
    recommendedProducts: recommendedProducts,
    nextPage: nextPage ?? this.nextPage,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

class HomeFeedController extends AsyncNotifier<HomeFeedState> {
  static const _pageSize = 3;

  HomeRepository get _repository => ref.read(homeRepositoryProvider);

  @override
  Future<HomeFeedState> build() async {
    final page = await _repository.fetchHome(page: 0, pageSize: _pageSize);
    return HomeFeedState.fromPage(page);
  }

  Future<void> refreshFeed() async {
    final previous = state.value;
    try {
      final page = await _repository.fetchHome(page: 0, pageSize: _pageSize);
      if (!ref.mounted) return;
      state = AsyncData(HomeFeedState.fromPage(page));
    } on Object catch (error, stackTrace) {
      if (!ref.mounted) return;
      state = previous == null
          ? AsyncError(error, stackTrace)
          : AsyncData(previous);
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await _repository.fetchHome(
        page: current.nextPage,
        pageSize: _pageSize,
      );
      if (!ref.mounted) return;
      state = AsyncData(
        current.copyWith(
          nearbyCafes: List.unmodifiable([
            ...current.nearbyCafes,
            ...page.nearbyCafes,
          ]),
          nextPage: page.page + 1,
          hasMore: page.hasMore,
          isLoadingMore: false,
        ),
      );
    } on Object {
      if (!ref.mounted) return;
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  void toggleFavorite(String cafeId) {
    final current = state.value;
    if (current == null) return;
    HomeCafe toggle(HomeCafe cafe) =>
        cafe.id == cafeId ? cafe.copyWith(isFavorite: !cafe.isFavorite) : cafe;
    state = AsyncData(
      current.copyWith(
        nearbyCafes: List.unmodifiable(current.nearbyCafes.map(toggle)),
        featuredCafes: List.unmodifiable(current.featuredCafes.map(toggle)),
      ),
    );
  }
}
