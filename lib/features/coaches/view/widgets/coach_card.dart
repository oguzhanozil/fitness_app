import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/themes/theme_colors.dart';
import '../../../../domain/models/coach_persona.dart';

Color _accentColor(String id) {
  return ThemeColors.coachAccentPalette[id.hashCode.abs() % ThemeColors.coachAccentPalette.length];
}

class _WoodGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ThemeColors.woodGrain.withValues(alpha: 0.14)
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;

    const lineCount = 20;
    for (int i = 0; i < lineCount; i++) {
      final y0 = size.height * (i / (lineCount - 1).toDouble());
      final path = Path();
      path.moveTo(0, y0);
      for (double x = 0; x <= size.width; x += 3) {
        final y = y0 + 1.8 * math.sin((x / size.width) * math.pi * 4 + i * 0.65);
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_WoodGrainPainter _) => false;
}

class CoachCard extends StatelessWidget {
  const CoachCard({required this.coach, required this.onTap, super.key});

  final CoachPersona coach;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(coach.id);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeColors.woodBorder.withValues(alpha: 0.50),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.woodShadow.withValues(alpha: 0.20),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: ThemeColors.woodShadow.withValues(alpha: 0.15),
            highlightColor: ThemeColors.woodShadow.withValues(alpha: 0.08),
            child: Ink(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ThemeColors.woodGradientLight,
                    ThemeColors.woodGradientMid,
                    ThemeColors.woodGradientDark,
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  // Wood grain overlay
                  Positioned.fill(
                    child: CustomPaint(painter: _WoodGrainPainter()),
                  ),
                  // Card content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: accent.withValues(alpha: 0.22),
                          child: Text(
                            coach.name.isNotEmpty ? coach.name[0].toUpperCase() : '?',
                            style: TextStyle(
                              color: accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          coach.name,
                          style: const TextStyle(
                            color: ThemeColors.woodTextPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            coach.title,
                            style: TextStyle(
                              color: accent,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          coach.description,
                          style: const TextStyle(
                            color: ThemeColors.woodTextSecondary,
                            fontSize: 12,
                            height: 1.4,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}