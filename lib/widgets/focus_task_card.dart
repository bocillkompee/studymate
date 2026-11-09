import 'package:flutter/material.dart';

import '../models/task.dart';
import '../utils/app_colors.dart';
import '../utils/date_formatter.dart';

class FocusTaskCard extends StatelessWidget {
  const FocusTaskCard({
    super.key,
    required this.nextTask,
    required this.completionRate,
    required this.doneCount,
    required this.totalCount,
  });

  final Task? nextTask;
  final double completionRate;
  final int doneCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Fokus berikutnya',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onNavyMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      nextTask?.title ?? 'Belum ada tugas aktif',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _ProgressRing(
                value: completionRate,
                doneCount: doneCount,
                totalCount: totalCount,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              const Icon(
                Icons.calendar_today_rounded,
                size: 15,
                color: AppColors.onNavyMuted,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  nextTask == null
                      ? 'Tambahkan tugas baru untuk mulai merencanakan belajar.'
                      : 'Tenggat ${formatDate(nextTask!.deadline)} · ${relativeDeadline(nextTask!.deadline)}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onNavyMuted,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.value,
    required this.doneCount,
    required this.totalCount,
  });

  final double value;
  final int doneCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$doneCount dari $totalCount tugas selesai',
      child: SizedBox(
        width: 72,
        height: 72,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CircularProgressIndicator(
              value: value,
              strokeWidth: 7,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              color: AppColors.blueBright,
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '$doneCount/$totalCount',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'selesai',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onNavyMuted,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
