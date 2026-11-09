import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class TaskSummaryCard extends StatelessWidget {
  const TaskSummaryCard({
    super.key,
    required this.total,
    required this.todo,
    required this.inProgress,
    required this.done,
  });

  final int total;
  final int todo;
  final int inProgress;
  final int done;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Ringkasan tugas',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                '$total tugas',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _SummaryItem(
                    count: todo,
                    label: 'Belum',
                    color: AppColors.muted,
                  ),
                ),
                const _SummaryDivider(),
                Expanded(
                  child: _SummaryItem(
                    count: inProgress,
                    label: 'Dikerjakan',
                    color: AppColors.blue,
                  ),
                ),
                const _SummaryDivider(),
                Expanded(
                  child: _SummaryItem(
                    count: done,
                    label: 'Selesai',
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.count,
    required this.label,
    required this.color,
  });

  final int count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text('$count', style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: AppColors.line,
    );
  }
}
