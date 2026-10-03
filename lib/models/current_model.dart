class CurrentModel {
  final double? wind_mph;
  final double? wind_kph;
  final double? wind_degree;
  final double? temp_c;
  final String? wind_dir;

  CurrentModel({
    required this.wind_mph,
    required this.wind_kph,
    required this.wind_degree,
    required this.wind_dir,
    required this.temp_c,
  });

  factory CurrentModel.fromJson(Map<String, dynamic> jsonData) {
    return CurrentModel(
      wind_mph: (jsonData['current']['wind_mph'] as num).toDouble(),
      temp_c: (jsonData['current']['temp_c'] as num).toDouble(),
      wind_kph: (jsonData['current']['wind_kph'] as num).toDouble(),
      wind_degree: (jsonData['current']['wind_degree'] as num).toDouble(),
      wind_dir: jsonData['current']['wind_dir'],
    );
  }
}
