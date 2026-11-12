import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character_model.dart';

class DetailScreen extends StatefulWidget {
  final Character character;
  const DetailScreen({super.key, required this.character});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getStringList('FAVORITES') ?? [];
    setState(() {
      _isFavorite = favs.contains(widget.character.id.toString());
    });
  }

  void _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getStringList('FAVORITES') ?? [];

    setState(() {
      if (_isFavorite) {
        favs.remove(widget.character.id.toString());
        _isFavorite = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.character.name} dihapus dari favorit')),
        );
      } else {
        favs.add(widget.character.id.toString());
        _isFavorite = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.character.name} ditambahkan ke favorit')),
        );
      }
    });
    await prefs.setStringList('FAVORITES', favs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.character.name),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(widget.character.image, width: 160, height: 160, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.character.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow('Status', widget.character.status),
                    _buildInfoRow('Species', widget.character.species),
                    _buildInfoRow('Gender', widget.character.gender),
                    _buildInfoRow('Origin', widget.character.origin),
                    _buildInfoRow('Location', widget.character.location),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}