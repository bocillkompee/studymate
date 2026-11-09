import '../models/task.dart';
import 'mock_data.dart';

class TaskService {
  const TaskService();

  Future<List<Task>> fetchTasks() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // TODO(API): ganti data contoh ini dengan GET /tasks dari REST API.
    return MockData.buildTasks();
  }

  Future<void> createTask(Task task) async {
    // TODO(API): kirim POST /tasks beserta token JWT.
    throw UnimplementedError('Integrasi REST API belum tersedia.');
  }

  Future<void> updateTask(Task task) async {
    // TODO(API): kirim PUT /tasks/{id} beserta token JWT.
    throw UnimplementedError('Integrasi REST API belum tersedia.');
  }

  Future<void> deleteTask(String id) async {
    // TODO(API): kirim DELETE /tasks/{id} beserta token JWT.
    throw UnimplementedError('Integrasi REST API belum tersedia.');
  }
}
