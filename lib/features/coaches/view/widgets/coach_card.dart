import 'package:flutter/material.dart';

import '../../../../core/themes/theme_colors.dart';

Color _accentColor(String seed) {
  return ThemeColors.coachAccentPalette[
    seed.hashCode.abs() % ThemeColors.coachAccentPalette.length
  ];
}

IconData _coachIcon(String branch) {
  final normalized = branch.toLowerCase();
  if (normalized.contains('diet')) {
      return Icons.restaurant_menu_rounded;
  }
  if (normalized.contains('fitness')) {
      return Icons.fitness_center_rounded;
  }
  if (normalized.contains('pilates')) {
      return Icons.self_improvement_rounded;
  }
  if (normalized.contains('yoga')) {
      return Icons.spa_rounded;
  }
  return Icons.person_rounded;
}

class CoachCard extends StatelessWidget {
  const CoachCard({
    required this.coachName,
    required this.coachBranch,
    this.description,
    this.avatarAsset,
    this.onTap,
    this.color,
    super.key,
  });

  final String coachName;
  final String coachBranch;
  final String? description;
  final String? avatarAsset;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? _accentColor('$coachName|$coachBranch');
    final dpr = MediaQuery.of(context).devicePixelRatio;
    const avatarSize = 44.0;
    final cacheSize = (avatarSize * dpr).round().clamp(64, 128);

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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: accent.withValues(alpha: 0.22),
                          child: ClipOval(
                            child: avatarAsset == null
                                ? Icon(
                                    _coachIcon(coachBranch),
                                    color: accent,
                                    size: 28,
                                  )
                                : Image.asset(
                                    avatarAsset!,
                                    width: avatarSize,
                                    height: avatarSize,
                                    fit: BoxFit.cover,
                                    isAntiAlias: true,
                                    filterQuality: FilterQuality.high,
                                    cacheWidth: cacheSize,
                                    cacheHeight: cacheSize,
                                    gaplessPlayback: true,
                                    errorBuilder: (_, _, _) => Icon(
                                      _coachIcon(coachBranch),
                                      color: accent,
                                      size: 28,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          coachName,
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
                            color: accent.withValues(alpha: 0.88),
                            border: Border.all(
                              color: accent,
                              width: 1.1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            coachBranch,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          description ?? '',
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