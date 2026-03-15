import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/services/firebase_remote_config_service.dart';
import 'repositories/chat_repository.dart';
import 'repositories/coach_repository.dart';
import 'services/firebase_ai_chat_service.dart';
import 'services/shared_preferences_local_storage_service.dart';
import 'firebase_options.dart';
import 'features/home/view/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final remoteConfigService = FirebaseRemoteConfigService();
  await remoteConfigService.init();
  final localStorageService = SharedPreferencesLocalStorageService();
  await localStorageService.init();
  final chatRepository = ChatRepository(
    aiChatService: FirebaseAiChatService(),
    localStorageService: localStorageService,
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (_) => MyApp(
        remoteConfigService: remoteConfigService,
        chatRepository: chatRepository,
      ),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.remoteConfigService,
    required this.chatRepository,
  });

  final FirebaseRemoteConfigService remoteConfigService;
  final ChatRepository chatRepository;

  @override
  Widget build(BuildContext context) {
    final coachRepository = CoachRepository(
      remoteConfigService: remoteConfigService,
    );

    return MaterialApp(
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      home: HomeScreen(
        coachRepository: coachRepository,
        chatRepository: chatRepository,
      ),
    );
  }
}
