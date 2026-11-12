import 'package:flutter/material.dart';
import '../models/episode_model.dart';
import '../services/api_service.dart';

class EpisodesScreen extends StatefulWidget {
  const EpisodesScreen({super.key});

  @override
  State<EpisodesScreen> createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends State<EpisodesScreen> {
  late Future<List<Episode>> _futureEpisodes;

  @override
  void initState() {
    super.initState();
    _futureEpisodes = ApiService.fetchEpisodes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Episode>>(
      future: _futureEpisodes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Episode tidak ditemukan.'));
        }

        final episodes = snapshot.data!;
        return ListView.builder(
          itemCount: episodes.length,
          itemBuilder: (context, index) {
            final episode = episodes[index];
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(episode.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Air Date: ${episode.airDate}'),
                trailing: Text(
                  episode.episodeCode,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5F6F5E)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}