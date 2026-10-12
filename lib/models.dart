
class Country {
  final String name;
  final String capital;
  final String region;
  final int population;

  Country({
    required this.name,
    required this.capital,
    required this.region,
    required this.population,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    final capitals = json['capital'] as List?;

    return Country(
      name: json['name']?['common'] ?? 'Unknown',
      capital: capitals != null && capitals.isNotEmpty
          ? capitals.first.toString()
          : 'No capital listed',
      region: json['region'] ?? 'Unknown',
      population: json['population'] ?? 0,
    );
  }
}

class RandomPerson {
  final String name;
  final String email;
  final String country;
  final String city;
  final String picture;

  RandomPerson({
    required this.name,
    required this.email,
    required this.country,
    required this.city,
    required this.picture,
  });

  factory RandomPerson.fromJson(Map<String, dynamic> json) {
    return RandomPerson(
      name:
          '${json['name']['first']} ${json['name']['last']}',
      email: json['email'] ?? 'No email',
      country: json['location']['country'] ?? 'Unknown',
      city: json['location']['city'] ?? 'Unknown',
      picture: json['picture']['thumbnail'] ?? '',
    );
  }
}

class PersonUpdate {
  final List<RandomPerson>? people;
  final String? error;

  PersonUpdate.success(this.people) : error = null;

  PersonUpdate.failure(this.error) : people = null;

  bool get hasError => error != null;
}
