import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';
import '../models/episode_model.dart';

class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  static Future<List<Character>> fetchCharacters({
    String status = 'all',
    String name = '',
  }) async {
    final Map<String, String> queryParams = {};
    if (status != 'all') {
      queryParams['status'] = status.toLowerCase();
    }
    if (name.trim().isNotEmpty) {
      queryParams['name'] = name.trim();
    }

    final uri = Uri.parse('$baseUrl/character').replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((e) => Character.fromJson(e)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Gagal memuat data karakter (${response.statusCode})');
    }
  }

  static Future<Character> fetchCharacterDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/character/$id'));
    if (response.statusCode == 200) {
      return Character.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat detail karakter');
    }
  }

  static Future<List<Episode>> fetchEpisodes() async {
    final response = await http.get(Uri.parse('$baseUrl/episode'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((e) => Episode.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat daftar episode');
    }
  }
}