import 'package:flutter/material.dart';

import '../../../../core/themes/theme_colors.dart';
import '../../../../domain/models/coach_persona.dart';

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
    return Scaffold(
      backgroundColor: ThemeColors.coachesBackground,
      appBar: AppBar(
        backgroundColor: ThemeColors.coachesAppBarBackground,
        foregroundColor: ThemeColors.coachesAppBarForeground,
        title: Text('${coach.name} • ${coach.title}'),
      ),
      body: body,
    );
  }
}
