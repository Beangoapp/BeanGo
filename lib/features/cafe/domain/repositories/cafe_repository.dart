import '../entities/cafe_entities.dart';

abstract interface class CafeRepository {
  Future<List<CafeSummary>> fetchCafes();
  Future<CafeDetails> fetchCafe(String cafeId);
  Future<CafeProduct> fetchProduct(String productId);
}
