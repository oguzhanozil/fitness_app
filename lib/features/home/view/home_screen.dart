import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/themes/theme_colors.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/repositories/coach_repository.dart';
import '../../../domain/models/coach_persona.dart';
import '../../../domain/models/conversation_summary.dart';
import '../../chat/view/chat_screen.dart';
import '../../coaches/view/coaches_screen.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../../history/view/history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.coachRepository,
    required this.chatRepository,
  });

  final CoachRepository coachRepository;
  final ChatRepository chatRepository;

  Future<void> _openCoachChat(BuildContext context, CoachPersona coach) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChatScreen(
          coach: coach,
          chatRepository: chatRepository,
        ),
      ),
    );

    if (context.mounted) {
      context.read<HomeCubit>().refreshHistory();
    }
  }

  Future<void> _openHistoryConversation(
    BuildContext context,
    ConversationSummary summary,
  ) async {
    final coach = await coachRepository.getCoachById(summary.coachId);
    if (!context.mounted || coach == null) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChatScreen(
          coach: coach,
          chatRepository: chatRepository,
          conversationId: summary.id,
        ),
      ),
    );

    if (context.mounted) {
      context.read<HomeCubit>().refreshHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final pages = <Widget>[
            CoachesScreen(
              coachRepository: coachRepository,
              onCoachTap: (coach) => _openCoachChat(context, coach),
            ),
            HistoryScreen(
              key: ValueKey('history_${state.historyRefreshToken}'),
              chatRepository: chatRepository,
              onConversationTap: (summary) =>
                  _openHistoryConversation(context, summary),
            ),
          ];

          return Scaffold(
            body: IndexedStack(index: state.currentIndex, children: pages),
            bottomNavigationBar: NavigationBar(
              backgroundColor: ThemeColors.coachesAppBarBackground,
              indicatorColor: ThemeColors.coachesNavIndicator,
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                final isSelected = states.contains(WidgetState.selected);
                return TextStyle(
                  color: isSelected
                      ? ThemeColors.coachesNavSelected
                      : ThemeColors.coachesNavUnselected,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                );
              }),
              selectedIndex: state.currentIndex,
              onDestinationSelected: context.read<HomeCubit>().selectTab,
              destinations: const [
                NavigationDestination(
                  icon: Icon(
                    Icons.groups_outlined,
                    color: ThemeColors.coachesNavUnselected,
                  ),
                  selectedIcon: Icon(
                    Icons.groups,
                    color: ThemeColors.coachesNavSelected,
                  ),
                  label: 'Coaches',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.history_outlined,
                    color: ThemeColors.coachesNavUnselected,
                  ),
                  selectedIcon: Icon(
                    Icons.history,
                    color: ThemeColors.coachesNavSelected,
                  ),
                  label: 'History',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}