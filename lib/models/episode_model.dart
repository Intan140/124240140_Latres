class Episode {
  final int id;
  final String name;
  final String airDate;
  final String episodeCode;

  Episode({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episodeCode,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      airDate: json['air_date'] ?? 'Unknown',
      episodeCode: json['episode'] ?? '',
    );
  }
}