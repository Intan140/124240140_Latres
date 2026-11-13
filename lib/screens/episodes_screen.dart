import 'package:flutter/material.dart';
import '../models/episode_model.dart';
import '../services/api_service.dart';

class EpisodeScreen extends StatefulWidget {
  const EpisodeScreen({super.key});

  @override
  State<EpisodeScreen> createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {
  late Future<List<Episode>> _episodesFuture;

  @override
  void initState() {
    super.initState();
    _episodesFuture = ApiService.fetchEpisodes();
  }

  @override
  Widget build(BuildContext context) {
    const purplePrimary = Color(0xFF8B6CE8);
    const purpleDark = Color(0xFF2A2142);
    const purpleSoft = Color(0xFFEDE8FA);

    return FutureBuilder<List<Episode>>(
      future: _episodesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Gagal memuat episode: ${snapshot.error}'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _episodesFuture = ApiService.fetchEpisodes();
                    });
                  },
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada data episode.'));
        }

        final episodes = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: episodes.length,
          itemBuilder: (context, index) {
            final ep = episodes[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: purpleSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        ep.episodeCode,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: purplePrimary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ep.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: purpleDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Air Date: ${ep.airDate}',
                            style: TextStyle(
                              fontSize: 13,
                              color: purpleDark.withAlpha(166), 
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
    );
  }
}