import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../constants/app_constants.dart';
import 'remote_config_service.dart';

class FirebaseRemoteConfigService implements RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<void> init() async {
    await _remoteConfig.setDefaults({
      for (final coach in AppConstants.coachDefinitions)
        AppConstants.remoteConfigKey(coach['id']!):
            AppConstants.defaultSystemInstructions[coach['id']] ?? '',
    });

    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {
    }
  }

  @override
  String getCoachSystemInstruction(String coachId) {
    final value = _remoteConfig
        .getString(AppConstants.remoteConfigKey(coachId))
        .trim();

    if (value.isEmpty) {
      return AppConstants.defaultSystemInstructions[coachId] ?? '';
    }
    return value;
  }
}