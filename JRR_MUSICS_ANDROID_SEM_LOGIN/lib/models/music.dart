class Music {
  const Music({
    required this.id,
    required this.title,
    required this.artist,
    required this.cover,
    required this.url,
    this.lyrics = const [],
  });

  final String id;
  final String title;
  final String artist;
  final String cover;
  final String url;
  final List<Lyric> lyrics;
}

class Lyric {
  const Lyric(this.milliseconds, this.text);
  final int milliseconds;
  final String text;
}
