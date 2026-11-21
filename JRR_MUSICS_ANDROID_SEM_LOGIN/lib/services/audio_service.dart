import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/music.dart';

class AudioService extends ChangeNotifier {
  final AudioPlayer player = AudioPlayer();
  final List<Music> _queue = [];
  int _index = 0;

  List<Music> get queue => List.unmodifiable(_queue);
  Music? get current => _queue.isEmpty ? null : _queue[_index];

  Future<void> init() async {
    player.playerStateStream.listen((_) => notifyListeners());
    player.positionStream.listen((_) => notifyListeners());
    player.currentIndexStream.listen((value) {
      if (value != null && value >= 0 && value < _queue.length) {
        _index = value;
      }
      notifyListeners();
    });
  }

  Future<void> play(Music music, {List<Music>? queue}) async {
    _queue
      ..clear()
      ..addAll(queue ?? [music]);
    _index = _queue.indexWhere((item) => item.id == music.id);
    if (_index < 0) _index = 0;

    final sources = _queue
        .map((item) => AudioSource.uri(Uri.parse(item.url)))
        .toList();

    await player.setAudioSources(sources, initialIndex: _index);
    await player.play();
    notifyListeners();
  }

  Future<void> toggle() async {
    if (player.playing) {
      await player.pause();
    } else if (_queue.isNotEmpty) {
      await player.play();
    }
    notifyListeners();
  }

  Future<void> next() async {
    if (player.hasNext) await player.seekToNext();
  }

  Future<void> previous() async {
    if (player.position > const Duration(seconds: 3)) {
      await player.seek(Duration.zero);
    } else if (player.hasPrevious) {
      await player.seekToPrevious();
    }
  }

  Future<void> seek(Duration position) => player.seek(position);

  Future<void> addToQueue(Music music) async {
    if (_queue.isEmpty) {
      await play(music);
      return;
    }
    final wasPlaying = player.playing;
    _queue.add(music);
    final currentPosition = player.position;
    final sources = _queue
        .map((item) => AudioSource.uri(Uri.parse(item.url)))
        .toList();
    await player.setAudioSources(sources, initialIndex: _index);
    await player.seek(currentPosition, index: _index);
    if (wasPlaying) await player.play();
    notifyListeners();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
