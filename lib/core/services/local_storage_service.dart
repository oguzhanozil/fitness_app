import '../../domain/models/chat_message.dart';
import '../../domain/models/conversation_summary.dart';

abstract class LocalStorageService {
  Future<void> init();

  //conversations
  Future<List<ConversationSummary>> getConversationSummaries();

  Future<void> saveConversationSummary(ConversationSummary summary);

  Future<void> deleteConversation(String conversationId);

  //messages

  Future<List<ChatMessage>> getMessages(String conversationId);

  Future<void> saveMessage(ChatMessage message);

  Future<void> clearMessages(String conversationId);
}
