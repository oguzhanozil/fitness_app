import 'package:equatable/equatable.dart';

import '../../../domain/models/conversation_summary.dart';

enum HistoryStatus { initial, loading, success, failure }

class HistoryState extends Equatable {
	const HistoryState({
		this.status = HistoryStatus.initial,
		this.summaries = const <ConversationSummary>[],
		this.errorMessage,
	});

	final HistoryStatus status;
	final List<ConversationSummary> summaries;
	final String? errorMessage;

	HistoryState copyWith({
		HistoryStatus? status,
		List<ConversationSummary>? summaries,
		String? errorMessage,
		bool clearErrorMessage = false,
	}) {
		return HistoryState(
			status: status ?? this.status,
			summaries: summaries ?? this.summaries,
			errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
		);
	}

	@override
	List<Object?> get props => [status, summaries, errorMessage];
}
