import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';
import '../providers/app_provider.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedStatus = 'all';
  String _searchQuery = '';
  late Future<List<Character>> _charactersFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _charactersFuture = ApiService.fetchCharacters(
        status: _selectedStatus,
        name: _searchQuery,
      );
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return const Color(0xFF569E73);
      case 'dead':
        return const Color(0xFFD96B8A);
      default:
        return const Color(0xFF8D85A3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    const purplePrimary = Color(0xFF8B6CE8);
    const purpleDark = Color(0xFF2A2142);
    const purpleSoft = Color(0xFFEDE8FA);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari nama karakter...',
              hintStyle: TextStyle(color: purpleDark.withAlpha(128)), // 0.5 * 255
              prefixIcon: const Icon(Icons.search, color: purplePrimary),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: purplePrimary),
                      onPressed: () {
                        _searchController.clear();
                        _searchQuery = '';
                        _loadData();
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onSubmitted: (value) {
              _searchQuery = value;
              _loadData();
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: ['all', 'alive', 'dead', 'unknown'].map((status) {
              final isSelected = _selectedStatus == status;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    status[0].toUpperCase() + status.substring(1),
                    style: TextStyle(
                      color: isSelected ? Colors.white : purpleDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: purplePrimary,
                 backgroundColor: const Color(0xFFF5F2FC),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onSelected: (_) {
                    _selectedStatus = status;
                    _loadData();
                  },
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Character>>(
            future: _charactersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off, size: 48, color: purplePrimary),
                      const SizedBox(height: 8),
                      Text('Gagal memuat data', style: TextStyle(color: purpleDark)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Karakter tidak ditemukan.'));
              }

              final characters = snapshot.data!;
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.74,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final char = characters[index];
                  final isFav = appProvider.isFavorite(char.id);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(characterId: char.id),
                        ),
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Hero(
                                  tag: 'char_${char.id}',
                                  child: Image.network(
                                    char.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      color: purpleSoft,
                                      child: const Icon(Icons.person, size: 50),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final added = await appProvider.toggleFavorite(char);
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: purpleDark,
                                          content: Text(
                                            added
                                                ? '${char.name} ditambahkan ke favorit'
                                                : '${char.name} dihapus dari favorit',
                                          ),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(230), // 0.92 * 255
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isFav ? Icons.favorite : Icons.favorite_border,
                                        size: 20,
                                        color: isFav ? const Color(0xFFD96B8A) : purpleDark,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  char.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: purpleDark,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(char.status).withAlpha(36), // 0.14 * 255
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(char.status),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        char.status,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: _getStatusColor(char.status),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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