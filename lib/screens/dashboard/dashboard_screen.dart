import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/task.dart';
import '../../services/app_state.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_spacing.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/focus_task_card.dart';
import '../../widgets/loading_panel.dart';
import '../../widgets/section_header.dart';
import '../../widgets/state_panel.dart';
import '../../widgets/task_card.dart';
import '../../widgets/task_summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.onSeeAllTasks});

  final VoidCallback onSeeAllTasks;

  void _openTaskForm(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.addTask);
  }

  void _openEditTask(BuildContext context, Task task) {
    Navigator.of(context).pushNamed(AppRoutes.editTask, arguments: task);
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final user = appState.user;
    final now = DateTime.now();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: appState.loadTasks,
          color: AppColors.blue,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  AppSpacing.lg,
                  AppSpacing.pagePadding,
                  AppSpacing.bottomContentPadding,
                ),
                children: <Widget>[
                  _GreetingHeader(
                    greeting: greetingFor(now),
                    name: user?.name ?? 'Pelajar',
                    initials: user?.initials ?? 'S',
                    today: now,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  if (appState.isLoadingTasks)
                    const LoadingPanel()
                  else if (appState.taskError != null)
                    StatePanel(
                      icon: Icons.cloud_off_rounded,
                      title: 'Tugas belum bisa dimuat',
                      message: appState.taskError!,
                      actionLabel: 'Coba lagi',
                      tone: StateTone.error,
                      onAction: appState.loadTasks,
                    )
                  else ...<Widget>[
                    FocusTaskCard(
                      nextTask: appState.nextTask,
                      completionRate: appState.completionRate,
                      doneCount: appState.doneCount,
                      totalCount: appState.totalTasks,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TaskSummaryCard(
                      total: appState.totalTasks,
                      todo: appState.todoCount,
                      inProgress: appState.inProgressCount,
                      done: appState.doneCount,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SectionHeader(
                      title: 'Tugas terbaru',
                      subtitle: 'Tiga tugas yang paling baru kamu tambahkan.',
                      actionLabel: 'Lihat semua',
                      onAction: onSeeAllTasks,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (appState.recentTasks.isEmpty)
                      StatePanel(
                        icon: Icons.checklist_rounded,
                        title: 'Belum ada tugas',
                        message:
                            'Tambahkan tugas pertamamu agar rencana belajar hari ini lebih jelas.',
                        actionLabel: 'Tambah tugas',
                        onAction: () => _openTaskForm(context),
                      )
                    else ...<Widget>[
                      for (
                        var index = 0;
                        index < appState.recentTasks.length;
                        index++
                      ) ...<Widget>[
                        if (index > 0) const SizedBox(height: AppSpacing.sm),
                        TaskCard(
                          task: appState.recentTasks[index],
                          compact: true,
                          onTap: () => _openEditTask(
                            context,
                            appState.recentTasks[index],
                          ),
                        ),
                      ],
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({
    required this.greeting,
    required this.name,
    required this.initials,
    required this.today,
  });

  final String greeting;
  final String name;
  final String initials;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$greeting,',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      formatFullDate(today),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Semantics(
          label: 'Avatar inisial $name',
          child: ExcludeSemantics(
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.blueTint,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                initials,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
