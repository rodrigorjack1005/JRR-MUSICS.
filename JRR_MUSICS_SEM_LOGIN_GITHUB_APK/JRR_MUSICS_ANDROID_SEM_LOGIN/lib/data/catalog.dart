import '../models/music.dart';

const genres = [
  'Sertanejo', 'Pagode', 'Funk', 'Pop', 'Rock',
  'Trap', 'Eletrônica', 'Gospel', 'Forró', 'MPB'
];

const artists = [
  'Ana Castela', 'Jorge & Mateus', 'Marília Mendonça',
  'Henrique & Juliano', 'Gusttavo Lima', 'Matuê',
  'Vintage Culture', 'The Weeknd'
];

final tracks = <Music>[
  const Music(
    id: '1',
    title: 'Som da Minha Terra',
    artist: 'JRR Sessions',
    cover: 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=900',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    lyrics: [
      Lyric(0, 'A música começa aqui'),
      Lyric(12000, 'No ritmo que faz lembrar'),
      Lyric(24000, 'Cada momento tem seu som'),
    ],
  ),
  const Music(
    id: '2',
    title: 'Noite de Verão',
    artist: 'JRR Sessions',
    cover: 'https://images.unsplash.com/photo-1506157786151-b8491531f063?w=900',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
  ),
  const Music(
    id: '3',
    title: 'Coração em Festa',
    artist: 'JRR Sessions',
    cover: 'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=900',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
  ),
  const Music(
    id: '4',
    title: 'Estrada e Saudade',
    artist: 'JRR Sessions',
    cover: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=900',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
  ),
];
