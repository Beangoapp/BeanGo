import 'package:flutter/widgets.dart';

class CafeStrings {
  CafeStrings(BuildContext context)
    : ar = Localizations.localeOf(context).languageCode == 'ar';
  final bool ar;
  String get menu => ar ? 'القائمة' : 'Menu';
  String get reviews => ar ? 'التقييمات' : 'Reviews';
  String get openingHours => ar ? 'ساعات العمل' : 'Opening hours';
  String get bestseller => ar ? 'الأكثر مبيعًا' : 'Bestseller';
  String get newArrival => ar ? 'جديد' : 'New';
  String get add => ar ? 'إضافة' : 'Add';
  String get addToCart => ar ? 'أضف إلى السلة' : 'Add to cart';
  String get unavailable => ar ? 'غير متوفر' : 'Unavailable';
  String get calories => ar ? 'سعرة حرارية' : 'calories';
  String get required => ar ? 'مطلوب' : 'Required';
  String get optional => ar ? 'اختياري' : 'Optional';
  String selectUpTo(int value) =>
      ar ? 'اختر حتى $value' : 'Choose up to $value';
  String get notes => ar ? 'ملاحظات للباريستا' : 'Notes for the barista';
  String get notesHint => ar ? 'مثال: حرارة أقل' : 'For example: less hot';
  String get saveCustomization =>
      ar ? 'حفظ التخصيص في المفضلة' : 'Save favorite customization';
  String get quantity => ar ? 'الكمية' : 'Quantity';
  String get chooseRequired =>
      ar ? 'اختر الخيارات المطلوبة' : 'Choose the required options';
  String get added => ar ? 'تمت الإضافة إلى السلة' : 'Added to cart';
  String get frequentlyTogether =>
      ar ? 'يُطلبان معًا غالبًا' : 'Frequently ordered together';
  String get recommended => ar ? 'قد يعجبك أيضًا' : 'You may also like';
  String get customerReviews => ar ? 'آراء العملاء' : 'Customer reviews';
  String get newest => ar ? 'الأحدث' : 'Newest';
  String get highestRated => ar ? 'الأعلى تقييمًا' : 'Highest rated';
  String get retry => ar ? 'إعادة المحاولة' : 'Retry';
  String get offlineTitle => ar ? 'لا يوجد اتصال' : "You're offline";
  String get errorTitle => ar ? 'تعذر تحميل المقهى' : "Couldn't load this café";
  String get emptyMenu =>
      ar ? 'لا توجد منتجات حاليًا' : 'No products available';
  String get open => ar ? 'مفتوح' : 'Open';
  String get closed => ar ? 'مغلق' : 'Closed';
  String qar(double value) => ar
      ? '${value.toStringAsFixed(0)} ر.ق'
      : 'QAR ${value.toStringAsFixed(0)}';
}
