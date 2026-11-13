import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final favorites = appProvider.favorites;
    const purplePrimary = Color(0xFF8B6CE8);
    const purpleDark = Color(0xFF2A2142);
    const purpleSoft = Color(0xFFEDE8FA);

    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: purpleSoft, shape: BoxShape.circle),
              child: const Icon(Icons.favorite_border, size: 48, color: purplePrimary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada karakter favorit.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: purpleDark),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final char = favorites[index];

        return Dismissible(
          key: Key(char.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFD96B8A),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
          ),
          onDismissed: (_) async {
            await appProvider.removeFavorite(char.id);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: purpleDark,
                content: Text('${char.name} dihapus dari favorit'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(characterId: char.id),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        char.image,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            char.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: purpleDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${char.status} • ${char.species}',
                            style: TextStyle(
                              color: purpleDark.withAlpha(166), 
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: purplePrimary),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}