import '../core/services/ai_chat_service.dart';
import '../core/services/local_storage_service.dart';
import '../domain/models/chat_message.dart';
import '../domain/models/coach_persona.dart';
import '../domain/models/conversation_summary.dart';

class ChatRepository {
	ChatRepository({
		required AiChatService aiChatService,
		required LocalStorageService localStorageService,
	})  : _aiChatService = aiChatService,
				_localStorageService = localStorageService;

	final AiChatService _aiChatService;
	final LocalStorageService _localStorageService;

	Future<void> startChat(CoachPersona coach) {
		return _aiChatService.startSession(
			systemInstruction: coach.systemInstruction,
		);
	}

	Future<List<ConversationSummary>> getConversationSummaries() async {
		final summaries = await _localStorageService.getConversationSummaries();
		summaries.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
		return summaries;
	}

	Future<List<ChatMessage>> getMessages(String conversationId) async {
		final messages = await _localStorageService.getMessages(conversationId);
		messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
		return messages;
	}

	Future<ChatMessage> sendMessage({
		required String conversationId,
		required CoachPersona coach,
		required String content,
	}) async {
		final trimmedContent = content.trim();
		if (trimmedContent.isEmpty) {
			throw ArgumentError('Message content cannot be empty.');
		}

		final userMessage = ChatMessage(
			id: _buildMessageId('user'),
			conversationId: conversationId,
			content: trimmedContent,
			role: MessageRole.user,
			timestamp: DateTime.now(),
		);

		await _localStorageService.saveMessage(userMessage);

		final history = await getMessages(conversationId);
		final buffer = StringBuffer();

		await for (final chunk in _aiChatService.sendMessage(trimmedContent, history)) {
			buffer.write(chunk);
		}

		final responseContent = buffer.toString().trim();
		if (responseContent.isEmpty) {
			throw StateError('AI service returned an empty response.');
		}

		final modelMessage = ChatMessage(
			id: _buildMessageId('model'),
			conversationId: conversationId,
			content: responseContent,
			role: MessageRole.model,
			timestamp: DateTime.now(),
		);

		await _localStorageService.saveMessage(modelMessage);
		await _localStorageService.saveConversationSummary(
			ConversationSummary(
				id: conversationId,
				coachId: coach.id,
				coachName: coach.name,
				lastMessage: modelMessage.content,
				lastMessageAt: modelMessage.timestamp,
				messageCount: history.length + 1,
			),
		);

		return modelMessage;
	}

	Future<void> deleteConversation(String conversationId) async {
		await _localStorageService.clearMessages(conversationId);
		await _localStorageService.deleteConversation(conversationId);
	}

	Future<void> saveConversationSnapshot({
		required String conversationId,
		required CoachPersona coach,
		required List<ChatMessage> messages,
	}) async {
		if (messages.isEmpty) {
			return;
		}

		final hasUserMessage = messages.any((message) => message.role == MessageRole.user);
		if (!hasUserMessage) {
			return;
		}

		final orderedMessages = List<ChatMessage>.from(messages)
			..sort((a, b) => a.timestamp.compareTo(b.timestamp));

		final visibleMessages = orderedMessages
				.where((message) => !message.id.startsWith('intro_'))
				.toList(growable: false);
		final lastMessage =
				visibleMessages.isNotEmpty ? visibleMessages.last : orderedMessages.last;

		await _localStorageService.saveConversationSummary(
			ConversationSummary(
				id: conversationId,
				coachId: coach.id,
				coachName: coach.name,
				lastMessage: lastMessage.content,
				lastMessageAt: lastMessage.timestamp,
				messageCount: visibleMessages.length,
			),
		);
	}

	void endChat() {
		_aiChatService.endSession();
	}

	String _buildMessageId(String prefix) {
		return '${prefix}_${DateTime.now().microsecondsSinceEpoch}';
	}
}
