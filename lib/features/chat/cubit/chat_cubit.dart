import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/chat_repository.dart';
import '../../../domain/models/chat_message.dart';
import '../../../domain/models/coach_persona.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
	ChatCubit({required ChatRepository chatRepository})
			: _chatRepository = chatRepository,
				super(const ChatState());

	final ChatRepository _chatRepository;

	Future<void> initializeChat(CoachPersona coach) async {
		await _initialize(
			coach: coach,
			conversationId: _buildConversationId(coach.id),
			isExistingConversation: false,
		);
	}

	Future<void> initializeExistingChat({
		required CoachPersona coach,
		required String conversationId,
	}) async {
		await _initialize(
			coach: coach,
			conversationId: conversationId,
			isExistingConversation: true,
		);
	}

	Future<void> _initialize({
		required CoachPersona coach,
		required String conversationId,
		required bool isExistingConversation,
	}) async {
		emit(
			state.copyWith(
				status: ChatStatus.loading,
				coach: coach,
				conversationId: conversationId,
				clearErrorMessage: true,
			),
		);

		try {
			await _chatRepository.startChat(coach);
			final restoredMessages = isExistingConversation
					? await _chatRepository.getMessages(conversationId)
					: <ChatMessage>[];
			final initialMessages = restoredMessages.isNotEmpty
					? restoredMessages
					: <ChatMessage>[
						_buildIntroMessage(coach: coach, conversationId: conversationId),
					];

			emit(
				state.copyWith(
					status: ChatStatus.ready,
					coach: coach,
					conversationId: conversationId,
					messages: initialMessages,
					clearErrorMessage: true,
				),
			);
		} catch (_) {
			emit(
				state.copyWith(
					status: ChatStatus.failure,
					coach: coach,
					errorMessage: 'Failed to start chat session. Please try again.',
				),
			);
		}
	}

	ChatMessage _buildIntroMessage({
		required CoachPersona coach,
		required String conversationId,
	}) {
		return ChatMessage(
			id: 'intro_$conversationId',
			conversationId: conversationId,
			content: 'Hi, I am ${coach.name}. Tell me what you need help with today.',
			role: MessageRole.model,
			timestamp: DateTime.now(),
		);
	}

	Future<void> sendMessage(String content) async {
		final coach = state.coach;
		final conversationId = state.conversationId;
		final trimmedContent = content.trim();

		if (coach == null || conversationId == null || trimmedContent.isEmpty || state.isBusy) {
			return;
		}

		final userMessage = ChatMessage(
			id: 'user_${DateTime.now().microsecondsSinceEpoch}',
			conversationId: conversationId,
			content: trimmedContent,
			role: MessageRole.user,
			timestamp: DateTime.now(),
		);

		final optimisticMessages = <ChatMessage>[...state.messages, userMessage];

		emit(
			state.copyWith(
				status: ChatStatus.sending,
				messages: optimisticMessages,
				clearDraftMessage: true,
				bumpComposerRevision: true,
				clearErrorMessage: true,
			),
		);

		try {
			final reply = await _chatRepository.sendMessage(
				conversationId: conversationId,
				coach: coach,
				content: trimmedContent,
			);

			emit(
				state.copyWith(
					status: ChatStatus.ready,
					messages: <ChatMessage>[...optimisticMessages, reply],
					clearDraftMessage: true,
					clearErrorMessage: true,
				),
			);
		} catch (_) {
			emit(
				state.copyWith(
					status: ChatStatus.failure,
					messages: optimisticMessages,
					clearDraftMessage: true,
					errorMessage: 'Failed to send message. Please try again.',
				),
			);
		}
	}

	void updateDraft(String value) {
		if (value == state.draftMessage) {
			return;
		}

		emit(state.copyWith(draftMessage: value));
	}

	Future<void> sendDraft() {
		return sendMessage(state.draftMessage);
	}

	@override
	Future<void> close() async {
		await _saveSnapshotOnClose();
		_chatRepository.endChat();
		return super.close();
	}

	Future<void> _saveSnapshotOnClose() async {
		final conversationId = state.conversationId;
		final coach = state.coach;

		if (conversationId == null || coach == null) {
			return;
		}

		try {
			await _chatRepository.saveConversationSnapshot(
				conversationId: conversationId,
				coach: coach,
				messages: state.messages,
			);
		} catch (_) {
			// Ignore persistence failures on dispose to avoid blocking navigation.
		}
	}

	String _buildConversationId(String coachId) {
		return '${coachId}_${DateTime.now().millisecondsSinceEpoch}';
	}
}

