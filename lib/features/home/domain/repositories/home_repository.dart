import '../entities/home_content.dart';

abstract interface class HomeRepository {
  Future<HomePage> fetchHome({required int page, required int pageSize});
}

enum HomeFailureType { offline, unavailable }

class HomeException implements Exception {
  const HomeException(this.type);

  final HomeFailureType type;
}
