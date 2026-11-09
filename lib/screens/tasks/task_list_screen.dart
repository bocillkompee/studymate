import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/task.dart';
import '../../services/app_state.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_spacing.dart';
import '../../utils/dialog_helpers.dart';
import '../../widgets/loading_panel.dart';
import '../../widgets/state_panel.dart';
import '../../widgets/task_card.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  TaskStatus? _selectedStatus;

  void _openAddTask() {
    Navigator.of(context).pushNamed(AppRoutes.addTask);
  }

  void _openEditTask(Task task) {
    Navigator.of(context).pushNamed(AppRoutes.editTask, arguments: task);
  }

  Future<void> _confirmDelete(Task task) async {
    final appState = AppScope.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: 'Hapus tugas?',
      message:
          'Tugas "${task.title}" akan dihapus dari daftar. Kamu masih bisa mengurungkannya lewat notifikasi.',
      confirmLabel: 'Hapus',
      destructive: true,
    );

    if (!confirmed || !mounted) {
      return;
    }

    appState.deleteTask(task.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Tugas "${task.title}" dihapus.'),
          action: SnackBarAction(
            label: 'Urungkan',
            onPressed: () => appState.addTask(task),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final visibleTasks = _selectedStatus == null
        ? appState.tasks
        : appState.tasks
              .where((task) => task.status == _selectedStatus)
              .toList();

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
                  Text(
                    'Tugas',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    _subtitleFor(appState),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: <Widget>[
                      _StatusFilterChip(
                        label: 'Semua',
                        selected: _selectedStatus == null,
                        onSelected: () {
                          setState(() => _selectedStatus = null);
                        },
                      ),
                      _StatusFilterChip(
                        label: 'Belum',
                        selected: _selectedStatus == TaskStatus.todo,
                        onSelected: () {
                          setState(() => _selectedStatus = TaskStatus.todo);
                        },
                      ),
                      _StatusFilterChip(
                        label: 'Proses',
                        selected: _selectedStatus == TaskStatus.inProgress,
                        onSelected: () {
                          setState(
                            () => _selectedStatus = TaskStatus.inProgress,
                          );
                        },
                      ),
                      _StatusFilterChip(
                        label: 'Selesai',
                        selected: _selectedStatus == TaskStatus.done,
                        onSelected: () {
                          setState(() => _selectedStatus = TaskStatus.done);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
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
                  else if (visibleTasks.isEmpty)
                    StatePanel(
                      icon: _selectedStatus == null
                          ? Icons.checklist_rounded
                          : Icons.filter_alt_off_rounded,
                      title: _selectedStatus == null
                          ? 'Belum ada tugas'
                          : 'Tidak ada tugas di filter ini',
                      message: _selectedStatus == null
                          ? 'Tambah tugas pertamamu agar semua rencana belajar tercatat rapi.'
                          : 'Coba pilih status lain atau kembali ke semua tugas.',
                      actionLabel: _selectedStatus == null
                          ? 'Tambah tugas'
                          : 'Tampilkan semua',
                      onAction: _selectedStatus == null
                          ? _openAddTask
                          : () => setState(() => _selectedStatus = null),
                    )
                  else ...<Widget>[
                    for (
                      var index = 0;
                      index < visibleTasks.length;
                      index++
                    ) ...<Widget>[
                      if (index > 0) const SizedBox(height: AppSpacing.sm),
                      TaskCard(
                        task: visibleTasks[index],
                        onTap: () => _openEditTask(visibleTasks[index]),
                        onEdit: () => _openEditTask(visibleTasks[index]),
                        onDelete: () => _confirmDelete(visibleTasks[index]),
                      ),
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

  String _subtitleFor(AppState appState) {
    if (appState.isLoadingTasks) {
      return 'Menyiapkan daftar tugasmu.';
    }
    if (appState.taskError != null) {
      return 'Daftar tugas belum tersedia.';
    }
    return '${appState.totalTasks} tugas, ${appState.todoCount} belum dimulai, ${appState.inProgressCount} dikerjakan.';
  }
}

class _StatusFilterChip extends StatelessWidget {
  const _StatusFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onSelected(),
    );
  }
}
