import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_service.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  String _format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioService>();
    final track = audio.current;

    if (track == null) {
      return const Scaffold(
        body: Center(child: Text('Escolha uma música para começar.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
        title: const Text('TOCANDO AGORA',
            style: TextStyle(fontSize: 12, letterSpacing: 2)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showQueue(context),
            icon: const Icon(Icons.queue_music),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          child: Column(
            children: [
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.network(
                  track.cover,
                  width: double.infinity,
                  height: 290,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 290,
                    color: const Color(0xFF202630),
                    child: const Center(
                        child: Icon(Icons.music_note, size: 80)),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(track.title,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w800)),
                        Text(track.artist,
                            style: const TextStyle(color: Colors.white60)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showLyrics(context, track),
                    icon: const Icon(Icons.lyrics_outlined,
                        color: Color(0xFFB8F35A), size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              StreamBuilder<Duration>(
                stream: audio.player.positionStream,
                builder: (_, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final total =
                      audio.player.duration ?? const Duration(seconds: 210);
                  final maxValue =
                      total.inMilliseconds.toDouble().clamp(1.0, double.infinity);
                  final sliderValue =
                      position.inMilliseconds.toDouble().clamp(0.0, maxValue);
                  return Column(
                    children: [
                      Slider(
                        value: sliderValue,
                        max: maxValue,
                        activeColor: const Color(0xFFB8F35A),
                        inactiveColor: Colors.white24,
                        onChanged: (value) => audio.seek(
                            Duration(milliseconds: value.round())),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_format(position),
                              style: const TextStyle(color: Colors.white54)),
                          Text(_format(total),
                              style: const TextStyle(color: Colors.white54)),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: audio.previous,
                      icon: const Icon(Icons.skip_previous, size: 39)),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFB8F35A),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: audio.toggle,
                      icon: Icon(
                        audio.player.playing ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                        size: 38,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: audio.next,
                      icon: const Icon(Icons.skip_next, size: 39)),
                ],
              ),
              const Spacer(),
              const Text("JRR MUSIC'S • SEU SOM, SEU MOMENTO",
                  style: TextStyle(
                      color: Colors.white30,
                      fontSize: 10,
                      letterSpacing: 1.1)),
            ],
          ),
        ),
      ),
    );
  }

  void _showQueue(BuildContext context) {
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
            ...queue.map((item) =>
                ListTile(title: Text(item.title), subtitle: Text(item.artist))),
          ],
        ),
      ),
    );
  }

  void _showLyrics(BuildContext context, dynamic track) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF151922),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('LETRA',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 18),
              if (track.lyrics.isEmpty)
                const Text('Letra não disponível para esta faixa.'),
              ...track.lyrics.map<Widget>((line) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Text(line.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 17)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
