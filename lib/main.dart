import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app/features/home/view/home_screen.dart';
import 'package:flutter/material.dart';

import 'core/services/firebase_remote_config_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final remoteConfigService = FirebaseRemoteConfigService();
  await remoteConfigService.init();

  runApp(MyApp(remoteConfigService: remoteConfigService));
}


class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.remoteConfigService,
  });

  final FirebaseRemoteConfigService remoteConfigService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(
      ),
    );
  }
}