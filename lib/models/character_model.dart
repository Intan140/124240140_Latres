class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String image;
  final String origin;
  final String location;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.origin,
    required this.location,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      species: json['species'] ?? '',
      gender: json['gender'] ?? '',
      image: json['image'] ?? '',
      origin: json['origin'] != null ? json['origin']['name'] ?? 'Unknown' : 'Unknown',
      location: json['location'] != null ? json['location']['name'] ?? 'Unknown' : 'Unknown',
    );
  }
}