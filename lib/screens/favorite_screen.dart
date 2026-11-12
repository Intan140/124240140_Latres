import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character_model.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Character> _favoriteCharacters = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavoriteCharacters();
  }

  Future<void> _loadFavoriteCharacters() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    List<String> favIds = prefs.getStringList('FAVORITES') ?? [];

    if (favIds.isEmpty) {
      setState(() {
        _favoriteCharacters = [];
        _isLoading = false;
      });
      return;
    }

    try {
      // Mengambil detail karakter favorit secara paralel menggunakan API endpoint /character/[ids]
      String idsString = favIds.join(',');
      final response = await http.get(Uri.parse('https://rickandmortyapi.com/api/character/$idsString'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Character> loadedChars = [];
        if (favIds.length == 1) {
          loadedChars.add(Character.fromJson(data));
        } else {
          loadedChars = (data as List).map((json) => Character.fromJson(json)).toList();
        }
        setState(() {
          _favoriteCharacters = loadedChars;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeFavorite(Character character) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favIds = prefs.getStringList('FAVORITES') ?? [];
    favIds.remove(character.id.toString());
    await prefs.setStringList('FAVORITES', favIds);

    setState(() {
      _favoriteCharacters.removeWhere((c) => c.id == character.id);
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${character.name} dihapus dari daftar favorit')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_favoriteCharacters.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada karakter favorit.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _favoriteCharacters.length,
      itemBuilder: (context, index) {
        final character = _favoriteCharacters[index];
        return Dismissible(
          key: Key(character.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            _removeFavorite(character);
          },
          child: Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(character.image)),
              title: Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Status: ${character.status}'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailScreen(character: character)),
                );
                _loadFavoriteCharacters();
              },
            ),
          ),
        );
      },
    );
  }
}