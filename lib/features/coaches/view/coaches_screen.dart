import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/themes/theme_colors.dart';
import '../../../data/repositories/coach_repository.dart';
import '../../../domain/models/coach_persona.dart';
import '../cubit/coaches_cubit.dart';
import '../cubit/coaches_state.dart';
import 'widgets/coach_card.dart';
import 'widgets/error_state.dart';

class CoachesScreen extends StatelessWidget {
	const CoachesScreen({
		super.key,
		required this.coachRepository,
		this.onCoachTap,
	});

	final CoachRepository coachRepository;
	final ValueChanged<CoachPersona>? onCoachTap;

	@override
	Widget build(BuildContext context) {
		return BlocProvider<CoachesCubit>(
			create: (_) => CoachesCubit(coachRepository: coachRepository)..loadCoaches(),
			child: Scaffold(
				backgroundColor: ThemeColors.coachesBackground,
				appBar: AppBar(
					backgroundColor: ThemeColors.coachesAppBarBackground,
					foregroundColor: ThemeColors.coachesAppBarForeground,
					title: const Text(
						'Coaches',
						style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
					),
					elevation: 0,
					bottom: PreferredSize(
						preferredSize: const Size.fromHeight(1),
						child: Container(height: 1, color: ThemeColors.coachesAppBarDivider),
					),
				),
				body: BlocBuilder<CoachesCubit, CoachesState>(
					builder: (context, state) {
						switch (state.status) {
							case CoachesStatus.initial:
							case CoachesStatus.loading:
								return const Center(child: CircularProgressIndicator());
							case CoachesStatus.failure:
								return ErrorState(
									message: state.errorMessage ?? 'error occurred',
									onRetry: () => context.read<CoachesCubit>().loadCoaches(),
								);
							case CoachesStatus.success:
								if (state.coaches.isEmpty) {
									return const Center(child: Text('Coaches not found'));
								}

								return GridView.builder(
								padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
								itemCount: state.coaches.length,
								gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
									crossAxisCount: 2,
									crossAxisSpacing: 12,
									mainAxisSpacing: 12,
									childAspectRatio: 0.75,
									),
									itemBuilder: (context, index) {
										final coach = state.coaches[index];
										return CoachCard(
											coach: coach,
											onTap: () => onCoachTap?.call(coach),
										);
									},
								);
						}
					},
				),
			),
		);
	}
}
