class AstronomyModel {
  final String? sunrise;
  final String? sunset;
  final String? moonrise;
  final String? moonset;

  AstronomyModel({
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
  });

  factory AstronomyModel.fromJson(Map<String, dynamic> jsonData) {
    return AstronomyModel(
      sunrise: jsonData['astronomy']['astro']['sunrise'],
      sunset: jsonData['astronomy']['astro']['sunset'],
      moonrise: jsonData['astronomy']['astro']['moonrise'],
      moonset: jsonData['astronomy']['astro']['moonset'],
    );
  }
}
