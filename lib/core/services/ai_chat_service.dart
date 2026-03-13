import '../../domain/models/chat_message.dart';

abstract class AiChatService {
  Future<void> startSession({required String systemInstruction});

  Stream<String> sendMessage(String message, List<ChatMessage> history);

  void endSession();
}
