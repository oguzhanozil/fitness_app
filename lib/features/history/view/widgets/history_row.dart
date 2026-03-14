import 'package:flutter/material.dart';

import '../../../../core/themes/theme_colors.dart';
import '../../../../domain/models/conversation_summary.dart';

class HistoryRow extends StatelessWidget {
  const HistoryRow({
    super.key,
    required this.summary,
    required this.onTap,
    required this.onDelete,
  });

  final ConversationSummary summary;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ThemeColors.woodTextPrimary, width: 1.2),
                ),
                child: Icon(
                  _iconForCoach(summary.coachId),
                  size: 18,
                  color: ThemeColors.woodTextPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            summary.coachName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: ThemeColors.woodTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _timeLabel(context, summary.lastMessageAt),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: ThemeColors.woodTextSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '"${summary.lastMessage}"',
                      style: const TextStyle(
                        fontSize: 12,
                        color: ThemeColors.woodTextSecondary,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                tooltip: 'Delete conversation',
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: ThemeColors.woodTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForCoach(String coachId) {
    switch (coachId) {
      case 'dietitian':
        return Icons.restaurant_menu;
      case 'fitness':
        return Icons.fitness_center;
      case 'pilates':
        return Icons.accessibility_new;
      case 'yoga':
        return Icons.self_improvement;
      default:
        return Icons.chat_bubble_outline;
    }
  }

  String _timeLabel(BuildContext context, DateTime timestamp) {
    final now = DateTime.now();
    final nowDate = DateTime(now.year, now.month, now.day);
    final tsDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
    final dayDiff = nowDate.difference(tsDate).inDays;

    if (dayDiff <= 0) {
      return MaterialLocalizations.of(context).formatTimeOfDay(
        TimeOfDay.fromDateTime(timestamp),
        alwaysUse24HourFormat: false,
      );
    }

    if (dayDiff == 1) {
      return 'Yesterday';
    }

    if (dayDiff < 7) {
      return '$dayDiff Days Ago';
    }

    final month = timestamp.month.toString().padLeft(2, '0');
    final day = timestamp.day.toString().padLeft(2, '0');
    return '$day/$month';
  }
}
