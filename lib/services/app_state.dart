import 'package:flutter/widgets.dart';

import '../models/task.dart';
import '../models/user.dart';
import 'task_service.dart';

class AppState extends ChangeNotifier {
  AppState({TaskService? taskService})
    : _taskService = taskService ?? const TaskService();

  final TaskService _taskService;
  final Map<String, String> _demoNames = <String, String>{};

  User? _user;
  List<Task> _tasks = const <Task>[];
  bool _isLoadingTasks = false;
  String? _taskError;
  int _loadGeneration = 0;

  User? get user => _user;
  List<Task> get tasks => List<Task>.unmodifiable(_tasks);
  bool get isLoadingTasks => _isLoadingTasks;
  String? get taskError => _taskError;

  int get totalTasks => _tasks.length;

  int get todoCount => _countByStatus(TaskStatus.todo);

  int get inProgressCount => _countByStatus(TaskStatus.inProgress);

  int get doneCount => _countByStatus(TaskStatus.done);

  double get completionRate {
    if (_tasks.isEmpty) {
      return 0;
    }
    return doneCount / _tasks.length;
  }

  List<Task> get recentTasks {
    final sorted = List<Task>.of(_tasks)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(3).toList();
  }

  Task? get nextTask {
    final activeTasks =
        _tasks.where((task) => task.status != TaskStatus.done).toList()
          ..sort((a, b) => a.deadline.compareTo(b.deadline));
    return activeTasks.isEmpty ? null : activeTasks.first;
  }

  void rememberDemoAccount({required String name, required String email}) {
    _demoNames[email.trim().toLowerCase()] = name.trim();
  }

  void signInDemo({required String email}) {
    final normalizedEmail = email.trim();
    final storedName = _demoNames[normalizedEmail.toLowerCase()];
    _user = User(
      id: 'demo-user',
      name: storedName ?? _displayNameFromEmail(normalizedEmail),
      email: normalizedEmail,
    );
    notifyListeners();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final generation = ++_loadGeneration;
    final requestedUser = _user;
    _isLoadingTasks = true;
    _taskError = null;
    notifyListeners();

    try {
      final loadedTasks = await _taskService.fetchTasks();
      if (generation != _loadGeneration || _user != requestedUser) {
        return;
      }
      _tasks = loadedTasks;
    } catch (_) {
      if (generation == _loadGeneration && _user == requestedUser) {
        _taskError =
            'Daftar tugas belum bisa dimuat. Periksa koneksi lalu coba lagi.';
      }
    } finally {
      if (generation == _loadGeneration) {
        _isLoadingTasks = false;
        notifyListeners();
      }
    }
  }

  String createTaskId() {
    return 'task-${DateTime.now().microsecondsSinceEpoch}';
  }

  void addTask(Task task) {
    // TODO(API): simpan melalui TaskService.createTask setelah backend siap.
    _tasks = <Task>[task, ..._tasks];
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    // TODO(API): simpan melalui TaskService.updateTask setelah backend siap.
    _tasks = _tasks
        .map((task) => task.id == updatedTask.id ? updatedTask : task)
        .toList();
    notifyListeners();
  }

  void deleteTask(String id) {
    // TODO(API): hapus melalui TaskService.deleteTask setelah backend siap.
    _tasks = _tasks.where((task) => task.id != id).toList();
    notifyListeners();
  }

  void signOut() {
    _loadGeneration++;
    _user = null;
    _tasks = const <Task>[];
    _taskError = null;
    _isLoadingTasks = false;
    notifyListeners();
  }

  int _countByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).length;
  }

  String _displayNameFromEmail(String email) {
    final localPart = email
        .split('@')
        .first
        .replaceAll(RegExp(r'[._-]+'), ' ')
        .trim();

    if (localPart.isEmpty) {
      return 'Pelajar';
    }

    return localPart
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((part) {
          return '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}';
        })
        .join(' ');
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope tidak ditemukan di widget tree.');
    return scope!.notifier!;
  }
}
