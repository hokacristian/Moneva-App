import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moneva/data/services/api_service.dart';
import 'package:moneva/data/providers/auth_provider.dart';
import 'package:moneva/data/providers/input_provider.dart';
import 'package:moneva/data/providers/outcome_provider.dart';
import 'package:moneva/data/providers/dampak_provider.dart';
import 'package:moneva/presentation/pages/onboarding/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GeolocatorPlatform.instance.checkPermission();
  await dotenv.load(fileName: 'assets/env/.env');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(ApiService())),
        ChangeNotifierProvider(create: (_) => InputProvider(ApiService())),
        ChangeNotifierProvider(create: (_) => OutcomeProvider(ApiService())),
        ChangeNotifierProvider(create: (_) => DampakProvider(ApiService())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moneva',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
