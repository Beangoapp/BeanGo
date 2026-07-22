import 'package:beango/features/home/application/home_providers.dart';
import 'package:beango/features/home/data/repositories/mock_home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        homeRepositoryProvider.overrideWithValue(
          const MockHomeRepository(delay: Duration.zero),
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  test('loads more pages without duplicating content', () async {
    final first = await container.read(homeFeedProvider.future);
    expect(first.nearbyCafes, hasLength(3));

    await container.read(homeFeedProvider.notifier).loadMore();
    final second = container.read(homeFeedProvider).requireValue;

    expect(second.nearbyCafes, hasLength(6));
    expect(second.nearbyCafes.map((cafe) => cafe.id).toSet(), hasLength(6));
  });

  test('toggles favorite state immutably', () async {
    final first = await container.read(homeFeedProvider.future);
    final cafe = first.nearbyCafes.first;

    container.read(homeFeedProvider.notifier).toggleFavorite(cafe.id);
    final updated = container.read(homeFeedProvider).requireValue;

    expect(updated.nearbyCafes.first.isFavorite, isNot(cafe.isFavorite));
  });
}
