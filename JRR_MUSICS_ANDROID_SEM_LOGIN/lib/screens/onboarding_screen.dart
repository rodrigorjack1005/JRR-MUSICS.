import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/catalog.dart';
import '../services/preferences_service.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int step = 0;
  final selectedGenres = <String>{};
  final selectedArtists = <String>{};

  @override
  Widget build(BuildContext context) {
    final choosingGenres = step == 0;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("JRR MUSIC'S",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
              const SizedBox(height: 24),
              LinearProgressIndicator(
                value: (step + 1) / 2,
                color: const Color(0xFFB8F35A),
                backgroundColor: Colors.white12,
              ),
              const SizedBox(height: 28),
              Text(
                choosingGenres ? 'Qual é a sua vibe?' : 'Quais artistas você curte?',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                choosingGenres
                    ? 'Escolha seus gêneros favoritos.'
                    : 'Selecione artistas para personalizar seu som.',
                style: const TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: choosingGenres
                    ? SingleChildScrollView(
                        child: Wrap(
                          spacing: 9,
                          runSpacing: 9,
                          children: genres.map((genre) {
                            final selected = selectedGenres.contains(genre);
                            return FilterChip(
                              label: Text(genre),
                              selected: selected,
                              selectedColor: const Color(0xFFB8F35A),
                              checkmarkColor: Colors.black,
                              labelStyle: TextStyle(
                                  color: selected ? Colors.black : Colors.white),
                              onSelected: (value) => setState(() {
                                value
                                    ? selectedGenres.add(genre)
                                    : selectedGenres.remove(genre);
                              }),
                            );
                          }).toList(),
                        ),
                      )
                    : ListView(
                        children: artists.map((artist) {
                          final selected = selectedArtists.contains(artist);
                          return CheckboxListTile(
                            value: selected,
                            activeColor: const Color(0xFFB8F35A),
                            title: Text(artist),
                            onChanged: (value) => setState(() {
                              value == true
                                  ? selectedArtists.add(artist)
                                  : selectedArtists.remove(artist);
                            }),
                          );
                        }).toList(),
                      ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFB8F35A),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                  ),
                  onPressed: _continue,
                  child: Text(choosingGenres ? 'Continuar' : 'Começar a ouvir'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _continue() async {
    if (step == 0) {
      if (selectedGenres.isEmpty) {
        _message('Escolha pelo menos um gênero.');
        return;
      }
      setState(() => step = 1);
      return;
    }

    if (selectedArtists.isEmpty) {
      _message('Escolha pelo menos um artista.');
      return;
    }

    await context.read<PreferencesService>().saveOnboarding(
          selectedGenres.toList(),
          selectedArtists.toList(),
        );

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _message(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(value)),
    );
  }
}
