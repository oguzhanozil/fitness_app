import 'package:equatable/equatable.dart';

import '../../../domain/models/chat_message.dart';
import '../../../domain/models/coach_persona.dart';

enum ChatStatus { initial, loading, ready, sending, failure }

class ChatState extends Equatable {
	const ChatState({
		this.status = ChatStatus.initial,
		this.coach,
		this.conversationId,
		this.messages = const <ChatMessage>[],
		this.draftMessage = '',
		this.composerRevision = 0,
		this.errorMessage,
	});

	final ChatStatus status;
	final CoachPersona? coach;
	final String? conversationId;
	final List<ChatMessage> messages;
	final String draftMessage;
	final int composerRevision;
	final String? errorMessage;

	bool get isBusy =>
			status == ChatStatus.loading || status == ChatStatus.sending;

	ChatState copyWith({
		ChatStatus? status,
		CoachPersona? coach,
		String? conversationId,
		List<ChatMessage>? messages,
		String? draftMessage,
		int? composerRevision,
		String? errorMessage,
		bool clearErrorMessage = false,
		bool clearDraftMessage = false,
		bool bumpComposerRevision = false,
	}) {
		return ChatState(
			status: status ?? this.status,
			coach: coach ?? this.coach,
			conversationId: conversationId ?? this.conversationId,
			messages: messages ?? this.messages,
			draftMessage: clearDraftMessage ? '' : draftMessage ?? this.draftMessage,
			composerRevision:
					bumpComposerRevision ? this.composerRevision + 1 : composerRevision ?? this.composerRevision,
			errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
		);
	}

	@override
	List<Object?> get props => [
			status,
			coach,
			conversationId,
			messages,
			draftMessage,
			composerRevision,
			errorMessage,
		];
}
