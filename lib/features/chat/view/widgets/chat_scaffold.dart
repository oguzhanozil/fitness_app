import 'package:flutter/material.dart';

import '../../../../core/themes/theme_colors.dart';
import '../../../../domain/models/coach_persona.dart';

IconData _coachIcon(String id) {
  switch (id) {
    case 'dietitian':
      return Icons.restaurant_menu_rounded;
    case 'fitness':
      return Icons.fitness_center_rounded;
    case 'pilates':
      return Icons.self_improvement_rounded;
    case 'yoga':
      return Icons.spa_rounded;
    default:
      return Icons.person_rounded;
  }
}

class ChatScaffold extends StatelessWidget {
  const ChatScaffold({
    super.key,
    required this.coach,
    required this.body,
  });

  final CoachPersona coach;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    const avatarSize = 24.0;
    final cacheSize = (avatarSize * dpr).round().clamp(48, 128);

    return Scaffold(
      backgroundColor: ThemeColors.coachesBackground,
      appBar: AppBar(
        backgroundColor: ThemeColors.coachesAppBarBackground,
        foregroundColor: ThemeColors.coachesAppBarForeground,
        title: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white.withValues(alpha: 0.22),
              child: ClipOval(
                child: Image.asset(
                  coach.avatarAsset,
                  width: avatarSize,
                  height: avatarSize,
                  fit: BoxFit.cover,
                  isAntiAlias: true,
                  filterQuality: FilterQuality.high,
                  cacheWidth: cacheSize,
                  cacheHeight: cacheSize,
                  errorBuilder: (_, _, _) => Icon(
                    _coachIcon(coach.id),
                    size: 16,
                    color: ThemeColors.coachesAppBarForeground,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${coach.name} • ${coach.title}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
