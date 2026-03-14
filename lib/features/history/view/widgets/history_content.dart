import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/theme_colors.dart';
import '../../../../domain/models/conversation_summary.dart';
import '../../cubit/history_cubit.dart';
import '../../cubit/history_state.dart';
import 'history_row.dart';

class HistoryContent extends StatelessWidget {
  const HistoryContent({
    super.key,
    required this.onConversationTap,
  });

  final ValueChanged<ConversationSummary>? onConversationTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        switch (state.status) {
          case HistoryStatus.initial:
          case HistoryStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case HistoryStatus.failure:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.errorMessage ?? 'Unable to load history.',
                    style: const TextStyle(color: ThemeColors.woodTextPrimary),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.read<HistoryCubit>().loadHistory(),
                    style: FilledButton.styleFrom(
                      backgroundColor: ThemeColors.coachesAppBarBackground,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          case HistoryStatus.success:
            if (state.summaries.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No chat history yet. Start a conversation from the Coaches tab.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: ThemeColors.woodTextPrimary),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<HistoryCubit>().loadHistory(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.86),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: ThemeColors.woodTextPrimary.withValues(alpha: 0.70),
                        width: 1.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeColors.woodShadow.withValues(alpha: 0.14),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
                          child: Text(
                            'Chat History',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: ThemeColors.woodTextPrimary,
                            ),
                          ),
                        ),
                        const Divider(height: 1, thickness: 1),
                        for (int index = 0; index < state.summaries.length; index++) ...[
                          HistoryRow(
                            summary: state.summaries[index],
                            onTap: () => onConversationTap?.call(state.summaries[index]),
                            onDelete: () => context
                                .read<HistoryCubit>()
                                .deleteConversation(state.summaries[index].id),
                          ),
                          if (index != state.summaries.length - 1)
                            const Divider(height: 1, thickness: 1),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
