import 'package:equatable/equatable.dart';

import '../../../domain/models/coach_persona.dart';

enum CoachesStatus { initial, loading, success, failure }

class CoachesState extends Equatable {
	const CoachesState({
		this.status = CoachesStatus.initial,
		this.coaches = const <CoachPersona>[],
		this.errorMessage,
	});

	final CoachesStatus status;
	final List<CoachPersona> coaches;
	final String? errorMessage;

	CoachesState copyWith({
		CoachesStatus? status,
		List<CoachPersona>? coaches,
		String? errorMessage,
		bool clearErrorMessage = false,
	}) {
		return CoachesState(
			status: status ?? this.status,
			coaches: coaches ?? this.coaches,
			errorMessage: clearErrorMessage
					? null
					: (errorMessage ?? this.errorMessage),
		);
	}

	@override
	List<Object?> get props => <Object?>[status, coaches, errorMessage];
}
