import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/chat_repository.dart';
import '../../../domain/models/coach_persona.dart';
import '../cubit/chat_cubit.dart';
import 'widgets/chat_view.dart';

class ChatScreen extends StatelessWidget {
	const ChatScreen({
		super.key,
		required this.coach,
		required this.chatRepository,
		this.conversationId,
	});

	final CoachPersona coach;
	final ChatRepository chatRepository;
	final String? conversationId;

	@override
	Widget build(BuildContext context) {
		return BlocProvider<ChatCubit>(
			create: (_) {
				final cubit = ChatCubit(chatRepository: chatRepository);
				final existingConversationId = conversationId;
				if (existingConversationId == null) {
					cubit.initializeChat(coach);
				} else {
					cubit.initializeExistingChat(
						coach: coach,
						conversationId: existingConversationId,
					);
				}
				return cubit;
			},
			child: ChatView(coach: coach),
		);
	}
}
