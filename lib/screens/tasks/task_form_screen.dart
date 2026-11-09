import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/task.dart';
import '../../services/app_state.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/app_text_field.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key, this.task});

  final Task? task;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _deadlineController;

  late DateTime _selectedDate;
  late TaskPriority _selectedPriority;
  late TaskStatus _selectedStatus;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    final initialDate = DateTime.now().add(const Duration(days: 1));
    final normalizedInitialDate = DateTime(
      initialDate.year,
      initialDate.month,
      initialDate.day,
    );

    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(
      text: task?.description ?? '',
    );
    _selectedDate = task?.deadline ?? normalizedInitialDate;
    _deadlineController = TextEditingController(
      text: formatDate(_selectedDate),
    );
    _selectedPriority = task?.priority ?? TaskPriority.medium;
    _selectedStatus = task?.status ?? TaskStatus.todo;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      helpText: 'Pilih tenggat tugas',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );
      _deadlineController.text = formatDate(_selectedDate);
    });
  }

  String? _validateTitle(String? value) {
    final title = value?.trim() ?? '';
    if (title.isEmpty) {
      return 'Judul tugas wajib diisi.';
    }
    if (title.length < 3) {
      return 'Judul minimal 3 karakter.';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    final description = value?.trim() ?? '';
    if (description.isEmpty) {
      return 'Deskripsi tugas wajib diisi.';
    }
    if (description.length < 5) {
      return 'Deskripsi minimal 5 karakter.';
    }
    return null;
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();

    final appState = AppScope.of(context);
    final existingTask = widget.task;
    final task = Task(
      id: existingTask?.id ?? appState.createTaskId(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      deadline: _selectedDate,
      priority: _selectedPriority,
      status: _selectedStatus,
      createdAt: existingTask?.createdAt ?? DateTime.now(),
    );

    // TODO(API): kirim task ke TaskService setelah backend REST tersedia.
    if (existingTask == null) {
      appState.addTask(task);
    } else {
      appState.updateTask(task);
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            existingTask == null
                ? 'Tugas baru ditambahkan.'
                : 'Perubahan tugas disimpan.',
          ),
        ),
      );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: AppBar(title: Text(_isEditing ? 'Edit tugas' : 'Tugas baru')),
        body: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  AppSpacing.sm,
                  AppSpacing.pagePadding,
                  AppSpacing.xxl,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _isEditing
                            ? 'Perbarui detail tugas tanpa mengubah tugas lain.'
                            : 'Catat detail tugas agar tenggat dan progresnya mudah dipantau.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppTextField(
                        label: 'Judul tugas',
                        hint: 'Contoh: Latihan fisika bab gerak',
                        controller: _titleController,
                        prefixIcon: Icons.title_rounded,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        validator: _validateTitle,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Deskripsi',
                        hint: 'Tuliskan detail atau target tugas',
                        controller: _descriptionController,
                        maxLines: 5,
                        minLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        validator: _validateDescription,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Tenggat',
                        hint: 'Pilih tanggal',
                        controller: _deadlineController,
                        prefixIcon: Icons.calendar_today_rounded,
                        readOnly: true,
                        onTap: _pickDate,
                        suffixIcon: IconButton(
                          onPressed: _pickDate,
                          tooltip: 'Pilih tenggat',
                          icon: const Icon(
                            Icons.edit_calendar_rounded,
                            size: 20,
                          ),
                        ),
                        validator: (_) {
                          if (_deadlineController.text.trim().isEmpty) {
                            return 'Tenggat wajib dipilih.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const _SelectionLabel(label: 'Prioritas'),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: <Widget>[
                          for (final priority in TaskPriority.values)
                            ChoiceChip(
                              label: Text(priority.label),
                              selected: _selectedPriority == priority,
                              showCheckmark: false,
                              avatar: Icon(
                                _priorityIcon(priority),
                                size: 16,
                                color: _selectedPriority == priority
                                    ? AppColors.blue
                                    : AppColors.muted,
                              ),
                              onSelected: (_) {
                                setState(() => _selectedPriority = priority);
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const _SelectionLabel(label: 'Status'),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: <Widget>[
                          for (final status in TaskStatus.values)
                            ChoiceChip(
                              label: Text(status.label),
                              selected: _selectedStatus == status,
                              showCheckmark: false,
                              avatar: Icon(
                                _statusIcon(status),
                                size: 16,
                                color: _selectedStatus == status
                                    ? AppColors.blue
                                    : AppColors.muted,
                              ),
                              onSelected: (_) {
                                setState(() => _selectedStatus = status);
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _save,
                          child: Text(
                            _isEditing ? 'Simpan perubahan' : 'Simpan tugas',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _priorityIcon(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => Icons.arrow_downward_rounded,
      TaskPriority.medium => Icons.remove_rounded,
      TaskPriority.high => Icons.arrow_upward_rounded,
    };
  }

  IconData _statusIcon(TaskStatus status) {
    return switch (status) {
      TaskStatus.todo => Icons.radio_button_unchecked_rounded,
      TaskStatus.inProgress => Icons.timelapse_rounded,
      TaskStatus.done => Icons.check_circle_outline_rounded,
    };
  }
}

class _SelectionLabel extends StatelessWidget {
  const _SelectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppColors.navy,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
