import 'package:flutter/material.dart';

import '../models/task.dart';
import '../utils/app_colors.dart';
import '../utils/date_formatter.dart';
import 'task_chips.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.compact = false,
  });

  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final deadlineColor = task.isOverdue ? AppColors.danger : AppColors.muted;

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        mouseCursor: onTap == null
            ? MouseCursor.defer
            : SystemMouseCursors.click,
        child: Padding(
          padding: EdgeInsets.all(compact ? 14 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  TaskPriorityChip(priority: task.priority),
                  const Spacer(),
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 13,
                    color: deadlineColor,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      formatDate(task.deadline),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: deadlineColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                task.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (!compact && task.description.isNotEmpty) ...<Widget>[
                const SizedBox(height: 6),
                Text(
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TaskStatusChip(
                        status: task.status,
                        compact: compact,
                      ),
                    ),
                  ),
                  if (onEdit != null)
                    IconButton(
                      onPressed: onEdit,
                      tooltip: 'Edit tugas',
                      icon: const Icon(Icons.edit_outlined, size: 20),
                    ),
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      tooltip: 'Hapus tugas',
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                        color: AppColors.danger,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
