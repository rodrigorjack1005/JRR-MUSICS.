import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/catalog.dart';
import '../services/audio_service.dart';
import '../services/preferences_service.dart';
import 'player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = context.read<PreferencesService>();
    final audio = context.read<AudioService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("JRR MUSIC'S",
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.1)),
        actions: [
          IconButton(
            onPressed: () => _showQueue(context),
            icon: const Icon(Icons.queue_music),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Color(0xFFB8F35A),
              child: Icon(Icons.person, color: Colors.black),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Text('Seu som, seu momento.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    )),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Escolha uma música e aproveite.',
                style: TextStyle(color: Colors.white60)),
          ),
          const SizedBox(height: 24),
          _heading('Destaques para você'),
          SizedBox(
            height: 205,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: tracks.length,
              separatorBuilder: (_, __) => const SizedBox(width: 13),
              itemBuilder: (_, index) {
                final track = tracks[index];
                return GestureDetector(
                  onTap: () => _start(context, track, tracks),
                  child: SizedBox(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            track.cover,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 150,
                              height: 150,
                              color: const Color(0xFF202630),
                              child: const Icon(Icons.music_note, size: 45),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(track.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(track.artist,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _heading('Músicas'),
          ...tracks.map((track) => ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    track.cover,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.music_note, size: 40),
                  ),
                ),
                title: Text(track.title),
                subtitle: Text(track.artist,
                    style: const TextStyle(color: Colors.white54)),
                trailing: IconButton(
                  icon: const Icon(Icons.add_to_queue),
                  onPressed: () => audio.addToQueue(track),
                ),
                onTap: () => _start(context, track, tracks),
              )),
          _heading('Seus gêneros'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 8,
              children: preferences.favoriteGenres
                  .map((genre) => Chip(
                        label: Text(genre),
                        backgroundColor: const Color(0xFF1B222C),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const _MiniPlayer(),
    );
  }

  static Widget _heading(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 23, 20, 13),
        child: Text(text,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
      );

  static Future<void> _start(
      BuildContext context, dynamic track, List<dynamic> queue) async {
    await context.read<AudioService>().play(track, queue: queue.cast());
    if (!context.mounted) return;
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const PlayerScreen()));
  }

  static void _showQueue(BuildContext context) {
    final queue = context.read<AudioService>().queue;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF151922),
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(
                title: Text('Fila de reprodução',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            if (queue.isEmpty)
              const ListTile(title: Text('Sua fila está vazia.')),
            ...queue.map((item) => ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.artist),
                )),
          ],
        ),
      ),
    );
  }
}

class _MiniPlayer extends StatelessWidget {
  const _MiniPlayer();

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioService>();
    final current = audio.current;
    if (current == null) return const SizedBox.shrink();

    return Material(
      color: const Color(0xFF202630),
      child: SafeArea(
        top: false,
        child: ListTile(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PlayerScreen())),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.network(current.cover,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.music_note)),
          ),
          title: Text(current.title,
              maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(current.artist),
          trailing: IconButton(
            onPressed: audio.toggle,
            icon: Icon(
              audio.player.playing ? Icons.pause_circle : Icons.play_circle,
              color: const Color(0xFFB8F35A),
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
