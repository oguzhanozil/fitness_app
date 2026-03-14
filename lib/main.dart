import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app/features/coaches/view/coaches_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/services/firebase_remote_config_service.dart';
import 'data/repositories/coach_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final remoteConfigService = FirebaseRemoteConfigService();
  await remoteConfigService.init();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (_) => MyApp(remoteConfigService: remoteConfigService),
    ),
  );
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
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      home: CoachesScreen(
        coachRepository: CoachRepository(
          remoteConfigService: remoteConfigService,
        ),
      ),
    );
  }
}