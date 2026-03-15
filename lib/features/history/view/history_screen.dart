import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/themes/theme_colors.dart';
import '../../../repositories/chat_repository.dart';
import '../../../domain/models/conversation_summary.dart';
import '../cubit/history_cubit.dart';
import 'widgets/history_content.dart';

class HistoryScreen extends StatelessWidget {
	const HistoryScreen({
		super.key,
		required this.chatRepository,
		this.onConversationTap,
	});

	final ChatRepository chatRepository;
	final ValueChanged<ConversationSummary>? onConversationTap;

	@override
	Widget build(BuildContext context) {
		return BlocProvider<HistoryCubit>(
			create: (_) => HistoryCubit(chatRepository: chatRepository)..loadHistory(),
			child: Scaffold(
				backgroundColor: ThemeColors.coachesBackground,
				appBar: AppBar(
					backgroundColor: ThemeColors.coachesAppBarBackground,
					foregroundColor: ThemeColors.coachesAppBarForeground,
					title: const Text('Chat History'),
				),
				body: HistoryContent(onConversationTap: onConversationTap),
			),
		);
	}
}

