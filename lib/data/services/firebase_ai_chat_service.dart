import 'package:firebase_ai/firebase_ai.dart';

import '../../core/services/ai_chat_service.dart';
import '../../domain/models/chat_message.dart';

class FirebaseAiChatService implements AiChatService {
  FirebaseAiChatService({
    FirebaseAI? firebaseAI,
    this.modelName = 'gemini-2.5-flash-lite',
  }) : _firebaseAI = firebaseAI ?? FirebaseAI.googleAI();

  final FirebaseAI _firebaseAI;
  final String modelName;

  GenerativeModel? _model;
  ChatSession? _chatSession;

  @override
  Future<void> startSession({required String systemInstruction}) async {
    _model = _firebaseAI.generativeModel(
      model: modelName,
      systemInstruction: Content.system(systemInstruction),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 900,
      ),
    );

    _chatSession = _model!.startChat();
  }

  @override
  Stream<String> sendMessage(String message, List<ChatMessage> history) async* {
    final hasHistoryContext = history.isNotEmpty;
    final session = _chatSession;
    if (session != null && !hasHistoryContext) {
      final response = await session.sendMessage(Content.text(message));
      final text = response.text?.trim();
      if (text != null && text.isNotEmpty) {
        yield text;
      }
      return;
    }

    final model = _model;
    if (model == null) {
      throw StateError('Session not initialized. Call startSession first.');
    }

    final prompt = history.map(_mapMessageToContent).toList(growable: false);
    final response = await model.generateContent(prompt);
    final text = response.text?.trim();
    if (text != null && text.isNotEmpty) {
      yield text;
    }
  }

  @override
  void endSession() {
    _chatSession = null;
    _model = null;
  }

  Content _mapMessageToContent(ChatMessage message) {
    final role = message.role == MessageRole.user ? 'user' : 'model';
    return Content(role, <Part>[TextPart(message.content)]);
  }
}
