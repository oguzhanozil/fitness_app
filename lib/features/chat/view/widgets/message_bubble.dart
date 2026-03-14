import 'package:flutter/material.dart';

import '../../../../core/themes/theme_colors.dart';
import '../../../../domain/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final backgroundColor = isUser
        ? ThemeColors.coachesAppBarBackground
        : Colors.white.withValues(alpha: 0.88);
    final textColor =
        isUser ? ThemeColors.coachesAppBarForeground : ThemeColors.woodTextPrimary;

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18),
            border: isUser
                ? null
                : Border.all(color: ThemeColors.woodBorder.withValues(alpha: 0.35)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Text(
              message.content,
              style: TextStyle(color: textColor, height: 1.35),
            ),
          ),
        ),
      ),
    );
  }
}
