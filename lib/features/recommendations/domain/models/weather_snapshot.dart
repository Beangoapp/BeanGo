enum WeatherCondition { clear, cloudy, rain, wind, snow, unknown }

class WeatherSnapshot {
  const WeatherSnapshot({
    required this.temperatureCelsius,
    required this.condition,
    required this.observedAt,
  });

  final double temperatureCelsius;
  final WeatherCondition condition;
  final DateTime observedAt;
}

class GeoPoint {
  const GeoPoint({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}
