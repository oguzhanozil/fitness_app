import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/theme_colors.dart';
import '../../../../domain/models/coach_persona.dart';
import '../../cubit/chat_cubit.dart';
import '../../cubit/chat_state.dart';
import 'chat_scaffold.dart';
import 'message_bubble.dart';
import 'message_composer.dart';

class ChatView extends StatelessWidget {
  const ChatView({
    super.key,
    required this.coach,
  });

  final CoachPersona coach;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null &&
          current.messages.isNotEmpty,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message == null) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        final hasMessages = state.messages.isNotEmpty;

        if (!hasMessages &&
            (state.status == ChatStatus.initial || state.status == ChatStatus.loading)) {
          return ChatScaffold(
            coach: coach,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (!hasMessages && state.status == ChatStatus.failure) {
          return ChatScaffold(
            coach: coach,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 44, color: ThemeColors.woodShadow),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage ?? 'Unable to open this chat right now.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: ThemeColors.woodTextPrimary),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.read<ChatCubit>().initializeChat(coach),
                      style: FilledButton.styleFrom(
                        backgroundColor: ThemeColors.coachesAppBarBackground,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return ChatScaffold(
          coach: coach,
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                    itemCount: state.messages.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return MessageBubble(message: message);
                    },
                  ),
                ),
                if (state.status == ChatStatus.sending)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Coach is thinking...',
                      style: TextStyle(color: ThemeColors.woodTextSecondary),
                    ),
                  ),
                MessageComposer(
                  fieldKey: ValueKey('composer_${state.composerRevision}'),
                  initialText: state.draftMessage,
                  onChanged: context.read<ChatCubit>().updateDraft,
                  isBusy: state.isBusy,
                  onSend: context.read<ChatCubit>().sendDraft,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
