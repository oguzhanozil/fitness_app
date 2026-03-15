import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/chat_repository.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
	HistoryCubit({required ChatRepository chatRepository})
			: _chatRepository = chatRepository,
				super(const HistoryState());

	final ChatRepository _chatRepository;

	Future<void> loadHistory() async {
		emit(state.copyWith(status: HistoryStatus.loading, clearErrorMessage: true));

		try {
			final summaries = await _chatRepository.getConversationSummaries();
			emit(
				state.copyWith(
					status: HistoryStatus.success,
					summaries: summaries,
					clearErrorMessage: true,
				),
			);
		} catch (_) {
			emit(
				state.copyWith(
					status: HistoryStatus.failure,
					errorMessage: 'Failed to load chat history. Please try again.',
				),
			);
		}
	}

	Future<void> deleteConversation(String conversationId) async {
		final updatedSummaries = state.summaries
				.where((summary) => summary.id != conversationId)
				.toList(growable: false);
		emit(
			state.copyWith(
				status: HistoryStatus.success,
				summaries: updatedSummaries,
				clearErrorMessage: true,
			),
		);

		try {
			await _chatRepository.deleteConversation(conversationId);
		} catch (_) {
			emit(
				state.copyWith(
					status: HistoryStatus.failure,
					errorMessage: 'Failed to delete conversation. Please try again.',
				),
			);
		}
	}
}

