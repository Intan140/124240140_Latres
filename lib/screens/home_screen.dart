import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Character>> _futureCharacters;
  String _selectedStatus = 'All';
  String _searchQuery = '';
  List<String> _favoriteIds = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _fetchData();
  }

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = prefs.getStringList('FAVORITES') ?? [];
    });
  }

  void _fetchData() {
    setState(() {
      _futureCharacters = ApiService.fetchCharacters(
        status: _selectedStatus,
        name: _searchQuery,
      );
    });
  }

  void _toggleFavorite(Character character) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteIds.contains(character.id.toString())) {
        _favoriteIds.remove(character.id.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${character.name} dihapus dari favorit')),
        );
      } else {
        _favoriteIds.add(character.id.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${character.name} ditambahkan ke favorit')),
        );
      }
    });
    await prefs.setStringList('FAVORITES', _favoriteIds);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bar Pencarian & Filter Status
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari karakter berdasarkan nama...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  _searchQuery = value;
                  _fetchData();
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['All', 'Alive', 'Dead', 'Unknown'].map((status) {
                  bool isSelected = _selectedStatus == status;
                  return ChoiceChip(
                    label: Text(status),
                    selected: isSelected,
                    selectedColor: const Color(0xFF8A9A86),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    onSelected: (selected) {
                      setState(() {
                        _selectedStatus = status;
                        _fetchData();
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        // List Karakter
        Expanded(
          child: FutureBuilder<List<Character>>(
            future: _futureCharacters,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Karakter tidak ditemukan.'));
              }

              final characters = snapshot.data!;
              return ListView.builder(
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final character = characters[index];
                  bool isFav = _favoriteIds.contains(character.id.toString());

                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(character.image),
                      ),
                      title: Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Status: ${character.status}'),
                      trailing: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        ),
                        onPressed: () => _toggleFavorite(character),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(character: character),
                          ),
                        );
                        _loadFavorites(); // Refresh data favorit ketika kembali
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}