import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class StudyMateLogo extends StatelessWidget {
  const StudyMateLogo({
    super.key,
    this.size = 48,
    this.showWordmark = false,
    this.onDark = false,
  });

  final double size;
  final bool showWordmark;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final markColor = onDark ? AppColors.blue : AppColors.navy;
    final checkBorderColor = onDark ? AppColors.blue : AppColors.navy;
    final titleColor = onDark ? Colors.white : AppColors.ink;
    final subtitleColor = onDark ? AppColors.onNavyMuted : AppColors.muted;

    // TODO(asset): ganti mark sementara ini dengan aset logo final.
    final mark = SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: markColor,
              borderRadius: BorderRadius.circular(size * 0.28),
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              size: size * 0.5,
              color: Colors.white,
            ),
          ),
          Positioned(
            right: -size * 0.05,
            bottom: -size * 0.05,
            child: Container(
              width: size * 0.38,
              height: size * 0.38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: checkBorderColor,
                  width: size * 0.035,
                ),
              ),
              child: Icon(
                Icons.check_rounded,
                size: size * 0.22,
                color: AppColors.blue,
              ),
            ),
          ),
        ],
      ),
    );

    if (!showWordmark) {
      return mark;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        mark,
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'StudyMate',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Belajar lebih teratur',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: subtitleColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
