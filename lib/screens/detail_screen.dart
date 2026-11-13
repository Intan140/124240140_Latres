import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';
import '../providers/app_provider.dart';

class DetailScreen extends StatefulWidget {
  final int characterId;

  const DetailScreen({super.key, required this.characterId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Future disimpan di state supaya API tidak dipanggil ulang
  // setiap kali favorit di-toggle (build dijalankan ulang).
  late Future<Character> _characterFuture;

  @override
  void initState() {
    super.initState();
    _characterFuture = ApiService.fetchCharacterDetail(widget.characterId);
  }

  void _retry() {
    setState(() {
      _characterFuture = ApiService.fetchCharacterDetail(widget.characterId);
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

  String _buildCharacterDescription(Character char) {
    final statusDesc = char.status.toLowerCase() == 'alive'
        ? 'masih hidup dan aktif menjelajahi multisemesta'
        : char.status.toLowerCase() == 'dead'
            ? 'telah dinyatakan meninggal dalam perjalanan lintas dimensi'
            : 'keberadaan serta kondisinya masih menjadi misteri';

    return '${char.name} adalah karakter berjenis ${char.species} (${char.gender}) yang berasal dari ${char.origin}. '
        'Saat ini, ${char.name} $statusDesc dengan lokasi terakhir yang diketahui berada di ${char.location}.';
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    const purplePrimary = Color(0xFF8B6CE8);
    const purpleDark = Color(0xFF2A2142);
    const purpleSoft = Color(0xFFEDE8FA);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: purpleSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: purplePrimary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: purpleDark.withAlpha(150),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: purpleDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    const purplePrimary = Color(0xFF8B6CE8);
    const purpleDark = Color(0xFF2A2142);

    return FutureBuilder<Character>(
      future: _characterFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Karakter')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Karakter')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 48, color: purplePrimary),
                  const SizedBox(height: 8),
                  const Text(
                    'Gagal memuat detail karakter',
                    style: TextStyle(color: purpleDark),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _retry,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        final char = snapshot.data!;
        final isFav = appProvider.isFavorite(char.id);
        final statusColor = _getStatusColor(char.status);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Character Detail'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? const Color(0xFFD96B8A) : purpleDark,
                  ),
                  onPressed: () async {
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
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Hero(
                    tag: 'char_${char.id}',
                    child: Image.network(
                      char.image,
                      width: double.infinity,
                      height: 290,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        char.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: purpleDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(150),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            char.status,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Deskripsi Karakter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: purplePrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _buildCharacterDescription(char),
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.55,
                    color: purpleDark.withAlpha(217),
                  ),
                ),
                const SizedBox(height: 22),
                const Divider(color: Color(0xFFE8E1F7)),
                const SizedBox(height: 8),
                const Text(
                  'Informasi Lengkap',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: purplePrimary,
                  ),
                ),
                const SizedBox(height: 6),
                _buildDetailRow(
                    Icons.category_outlined, 'Species', char.species),
                _buildDetailRow(Icons.wc_outlined, 'Gender', char.gender),
                _buildDetailRow(Icons.public_outlined, 'Origin', char.origin),
                _buildDetailRow(Icons.location_on_outlined,
                    'Last Known Location', char.location),
              ],
            ),
          ),
        );
      },
    );
  }
}