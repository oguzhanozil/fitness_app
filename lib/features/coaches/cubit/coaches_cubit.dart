import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/coach_repository.dart';
import 'coaches_state.dart';

class CoachesCubit extends Cubit<CoachesState> {
	CoachesCubit({required CoachRepository coachRepository})
			: _coachRepository = coachRepository,
				super(const CoachesState());

	final CoachRepository _coachRepository;

	Future<void> loadCoaches() async {
		emit(state.copyWith(status: CoachesStatus.loading, clearErrorMessage: true));

		try {
			final coaches = await _coachRepository.getCoaches();
			emit(
				state.copyWith(
					status: CoachesStatus.success,
					coaches: coaches,
					clearErrorMessage: true,
				),
			);
		} catch (_) {
			emit(
				state.copyWith(
					status: CoachesStatus.failure,
					errorMessage: 'Failed to load coaches. Please try again.',
				),
			);
		}
	}
}
