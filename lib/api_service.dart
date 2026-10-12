
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  static const Duration timeout = Duration(seconds: 10);

  static Future<List<Country>> fetchCountries() async {
    final uri = Uri.parse(
      'https://restcountries.com/v3.1/all'
      '?fields=name,capital,region,population',
    );

    try {
      final response = await http.get(uri).timeout(timeout);

      if (response.statusCode != 200) {
        throw Exception(
          'Server error: HTTP ${response.statusCode}',
        );
      }

      final List<dynamic> data = jsonDecode(response.body);

      final countries = data
          .map((item) => Country.fromJson(
              item as Map<String, dynamic>))
          .toList();

      countries.sort((a, b) => a.name.compareTo(b.name));

      return countries;
    } on TimeoutException {
      throw Exception('The request timed out. Please try again.');
    } on http.ClientException {
      throw Exception(
        'Cannot connect to the server. Check your internet.',
      );
    } on FormatException {
      throw Exception('The server returned invalid JSON.');
    }
  }

  static Future<List<RandomPerson>> fetchPeople() async {
    final uri = Uri.parse(
      'https://randomuser.me/api/?results=5',
    );

    try {
      final response = await http.get(uri).timeout(timeout);

      if (response.statusCode != 200) {
        throw Exception(
          'Server error: HTTP ${response.statusCode}',
        );
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body);

      final List<dynamic> results = data['results'];

      return results
          .map((item) => RandomPerson.fromJson(
              item as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw Exception('The request timed out.');
    } on http.ClientException {
      throw Exception(
        'No internet connection. Check your network.',
      );
    } on FormatException {
      throw Exception('The server returned invalid JSON.');
    }
  }

  // Each polling cycle catches its own error.
  // A failed request will not close the stream.

static Stream<PersonUpdate> peopleStream() {
  return Stream.periodic(
    const Duration(seconds: 5),
  ).asyncMap((_) async {
    try {
      final people = await fetchPeople();
      return PersonUpdate.success(people);
    } catch (e) {
      return PersonUpdate.failure(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  });
}
}