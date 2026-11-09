import '../models/task.dart';

abstract final class MockData {
  static List<Task> buildTasks() {
    final now = DateTime.now();

    DateTime day(int offset) {
      return DateTime(now.year, now.month, now.day).add(Duration(days: offset));
    }

    DateTime createdHoursAgo(int hours) {
      return now.subtract(Duration(hours: hours));
    }

    return <Task>[
      Task(
        id: 'task-01',
        title: 'Selesaikan latihan fisika bab gerak',
        description:
            'Kerjakan 15 soal pilihan ganda dan tulis ulang rumus yang sering keliru.',
        deadline: day(0),
        priority: TaskPriority.high,
        status: TaskStatus.inProgress,
        createdAt: createdHoursAgo(2),
      ),
      Task(
        id: 'task-02',
        title: 'Susun esai bahasa Indonesia',
        description:
            'Buat kerangka esai tentang peran perpustakaan sekolah, lalu kembangkan menjadi lima paragraf.',
        deadline: day(3),
        priority: TaskPriority.high,
        status: TaskStatus.todo,
        createdAt: createdHoursAgo(6),
      ),
      Task(
        id: 'task-03',
        title: 'Review ulangan kimia',
        description:
            'Ulangi materi stoikiometri dan kerjakan contoh soal dari catatan kelas.',
        deadline: day(5),
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        createdAt: createdHoursAgo(9),
      ),
      Task(
        id: 'task-04',
        title: 'Presentasi kelompok IPA',
        description:
            'Rapikan slide bagian kesimpulan dan latihan presentasi bersama kelompok.',
        deadline: day(4),
        priority: TaskPriority.medium,
        status: TaskStatus.inProgress,
        createdAt: createdHoursAgo(26),
      ),
      Task(
        id: 'task-05',
        title: 'Rangkuman ekonomi',
        description:
            'Ringkas materi permintaan dan penawaran dalam satu halaman catatan.',
        deadline: day(-1),
        priority: TaskPriority.medium,
        status: TaskStatus.done,
        createdAt: createdHoursAgo(40),
      ),
      Task(
        id: 'task-06',
        title: 'Latihan kosakata bahasa Inggris',
        description:
            'Hafalkan 20 kosakata baru dan buat satu kalimat untuk masing-masing kata.',
        deadline: day(1),
        priority: TaskPriority.low,
        status: TaskStatus.todo,
        createdAt: createdHoursAgo(50),
      ),
      Task(
        id: 'task-07',
        title: 'Tugas matematika',
        description:
            'Selesaikan latihan fungsi kuadrat nomor 1 sampai 10 di buku kerja.',
        deadline: day(-2),
        priority: TaskPriority.high,
        status: TaskStatus.done,
        createdAt: createdHoursAgo(60),
      ),
      Task(
        id: 'task-08',
        title: 'Membaca bab 4 sejarah',
        description:
            'Baca bab tentang pergerakan nasional dan tandai bagian yang perlu ditanyakan.',
        deadline: day(-3),
        priority: TaskPriority.low,
        status: TaskStatus.done,
        createdAt: createdHoursAgo(72),
      ),
    ];
  }
}
