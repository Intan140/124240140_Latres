import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';
import '../models/episode_model.dart';

class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  static Future<List<Character>> fetchCharacters({String? status, String? name}) async {
    String url = '$baseUrl/character';
    Map<String, String> queryParams = {};
    if (status != null && status.isNotEmpty && status != 'All') {
      queryParams['status'] = status.toLowerCase();
    }
    if (name != null && name.isNotEmpty) {
      queryParams['name'] = name;
    }

    if (queryParams.isNotEmpty) {
      url += '?' + queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List results = data['results'];
      return results.map((json) => Character.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      return []; // Tidak ditemukan
    } else {
      throw Exception('Gagal memuat data karakter');
    }
  }

  static Future<List<Episode>> fetchEpisodes() async {
    final response = await http.get(Uri.parse('$baseUrl/episode'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List results = data['results'];
      return results.map((json) => Episode.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data episode');
    }
  }
}