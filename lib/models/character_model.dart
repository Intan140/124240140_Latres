class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String origin;
  final String location;
  final String image;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? 'unknown',
      species: json['species'] ?? '',
      gender: json['gender'] ?? '',
      origin: json['origin'] is Map
          ? (json['origin']['name'] ?? 'Unknown')
          : (json['origin'] ?? 'Unknown'),
      location: json['location'] is Map
          ? (json['location']['name'] ?? 'Unknown')
          : (json['location'] ?? 'Unknown'),
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'gender': gender,
      'origin': origin,
      'location': location,
      'image': image,
    };
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      status: map['status'] ?? 'unknown',
      species: map['species'] ?? '',
      gender: map['gender'] ?? '',
      origin: map['origin'] ?? 'Unknown',
      location: map['location'] ?? 'Unknown',
      image: map['image'] ?? '',
    );
  }
}