import '../../core/constants/app_constants.dart';
import '../../core/services/remote_config_service.dart';
import '../../domain/models/coach_persona.dart';

class CoachRepository {
	CoachRepository({required RemoteConfigService remoteConfigService})
			: _remoteConfigService = remoteConfigService;

	final RemoteConfigService _remoteConfigService;

	Future<List<CoachPersona>> getCoaches() async {
		return AppConstants.coachDefinitions
				.map(
					(coach) => CoachPersona(
						id: coach['id']!,
						name: coach['name']!,
						title: coach['title']!,
						description: coach['description']!,
						avatarAsset: coach['avatarAsset']!,
						systemInstruction:
								_remoteConfigService.getCoachSystemInstruction(coach['id']!),
					),
				)
				.toList(growable: false);
	}

	Future<CoachPersona?> getCoachById(String coachId) async {
		final coaches = await getCoaches();

		for (final coach in coaches) {
			if (coach.id == coachId) {
				return coach;
			}
		}

		return null;
	}
}
