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

								CoachPersona coachById(String id) {
									return state.coaches.firstWhere((coach) => coach.id == id);
								}

								final dietitian = coachById('dietitian');
								final fitness = coachById('fitness');
								final pilates = coachById('pilates');
								final yoga = coachById('yoga');

								return GridView.count(
									padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
									crossAxisCount: 2,
									crossAxisSpacing: 12,
									mainAxisSpacing: 12,
									childAspectRatio: 0.75,
									children: [
										CoachCard(
											coachName: dietitian.name,
											coachBranch: dietitian.title,
											description: dietitian.description,
											avatarAsset: dietitian.avatarAsset,
											color: ThemeColors.coachDietitianAccent,
											onTap: () => onCoachTap?.call(dietitian),
										),
										CoachCard(
											coachName: fitness.name,
											coachBranch: fitness.title,
											description: fitness.description,
											avatarAsset: fitness.avatarAsset,
											color: ThemeColors.coachFitnessAccent,
											onTap: () => onCoachTap?.call(fitness),
										),
										CoachCard(
											coachName: pilates.name,
											coachBranch: pilates.title,
											description: pilates.description,
											avatarAsset: pilates.avatarAsset,
											color: ThemeColors.coachPilatesAccent,
											onTap: () => onCoachTap?.call(pilates),
										),
										CoachCard(
											coachName: yoga.name,
											coachBranch: yoga.title,
											description: yoga.description,
											avatarAsset: yoga.avatarAsset,
											color: ThemeColors.coachYogaAccent,
											onTap: () => onCoachTap?.call(yoga),
										),
									],
								);
						}
					},
				),
			),
		);
	}
}
