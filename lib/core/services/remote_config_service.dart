abstract class RemoteConfigService {
  Future<void> init();

  String getCoachSystemInstruction(String coachId);
}
