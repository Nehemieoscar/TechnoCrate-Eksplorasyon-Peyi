class Peyi {
  final String name;
  final String capital;
  final String region;
  final String flagUrl;
  final int? population;

  Peyi({
    required this.name,
    required this.capital,
    required this.region,
    required this.flagUrl,
    this.population,
  });

  factory Peyi.fromJson(Map<String, dynamic> json) {
    return Peyi(
      name: json['name']?['common'] ?? 'Unknown',
      capital: json['capital'] != null
          ? (json['capital'] as List).join(', ')
          : 'Pa gen kapital',
      region: json['region'] ?? 'Pa gen rejyon',
      flagUrl: json['flags']?['png'] ?? '',
      population: json['population'],
    );
  }

  String formatPopulation() {
    if (population == null) return 'Pa gen done';
    if (population! >= 1000000) {
      return '${(population! / 1000000).toStringAsFixed(1)}M';
    } else if (population! >= 1000) {
      return '${(population! / 1000).toStringAsFixed(1)}K';
    }
    return population.toString();
  }
}
