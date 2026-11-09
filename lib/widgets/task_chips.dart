import 'package:flutter/material.dart';

import '../models/task.dart';
import '../utils/app_colors.dart';

class TaskStatusChip extends StatelessWidget {
  const TaskStatusChip({super.key, required this.status, this.compact = false});

  final TaskStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final tone = switch (status) {
      TaskStatus.todo => (
        label: compact ? status.shortLabel : status.label,
        foreground: AppColors.muted,
        background: AppColors.slateTint,
        icon: Icons.radio_button_unchecked_rounded,
      ),
      TaskStatus.inProgress => (
        label: compact ? status.shortLabel : status.label,
        foreground: AppColors.blue,
        background: AppColors.blueTint,
        icon: Icons.timelapse_rounded,
      ),
      TaskStatus.done => (
        label: compact ? status.shortLabel : status.label,
        foreground: AppColors.success,
        background: AppColors.successTint,
        icon: Icons.check_circle_outline_rounded,
      ),
    };

    return _StatusPill(
      label: tone.label,
      foreground: tone.foreground,
      background: tone.background,
      icon: tone.icon,
    );
  }
}

class TaskPriorityChip extends StatelessWidget {
  const TaskPriorityChip({super.key, required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final tone = switch (priority) {
      TaskPriority.low => (
        label: priority.label,
        foreground: AppColors.muted,
        background: AppColors.slateTint,
      ),
      TaskPriority.medium => (
        label: priority.label,
        foreground: AppColors.warning,
        background: AppColors.warningTint,
      ),
      TaskPriority.high => (
        label: priority.label,
        foreground: AppColors.danger,
        background: AppColors.dangerTint,
      ),
    };

    return _StatusPill(
      label: tone.label,
      foreground: tone.foreground,
      background: tone.background,
      icon: Icons.flag_rounded,
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.foreground,
    required this.background,
    required this.icon,
  });

  final String label;
  final Color foreground;
  final Color background;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 13, color: foreground),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
