import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/audio_service.dart';
import 'services/preferences_service.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = PreferencesService();
  await preferences.init();
  final audio = AudioService();
  await audio.init();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: preferences),
        ChangeNotifierProvider.value(value: audio),
      ],
      child: const JrrMusicApp(),
    ),
  );
}

class JrrMusicApp extends StatelessWidget {
  const JrrMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = context.read<PreferencesService>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "JRR MUSIC'S",
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090B10),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFB8F35A),
          secondary: Color(0xFFB8F35A),
          surface: Color(0xFF151922),
        ),
        useMaterial3: true,
      ),
      home: preferences.hasCompletedOnboarding
          ? const HomeScreen()
          : const OnboardingScreen(),
    );
  }
}
