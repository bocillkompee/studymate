import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';

Future<void> _setPhoneSize(
  WidgetTester tester, {
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _openLogin(WidgetTester tester) async {
  await tester.pumpWidget(const StudyMateApp());
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

Future<void> _login(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField).at(0), 'rani@sekolah.id');
  await tester.enterText(find.byType(TextFormField).at(1), 'rahasia123');
  await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('splash membuka login dan validasi form berjalan', (
    tester,
  ) async {
    await _setPhoneSize(tester);
    await _openLogin(tester);

    expect(find.text('Selamat datang kembali'), findsOneWidget);

    await tester.tap(find.byTooltip('Tampilkan kata sandi'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Sembunyikan kata sandi'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Email wajib diisi.'), findsOneWidget);
    expect(find.text('Kata sandi wajib diisi.'), findsOneWidget);
  });

  testWidgets('login membuka dashboard dan data tugas tampil', (tester) async {
    await _setPhoneSize(tester);
    await _openLogin(tester);
    await _login(tester);

    expect(find.text('Rani'), findsOneWidget);
    expect(find.text('Ringkasan tugas'), findsOneWidget);
    expect(find.text('Tugas terbaru'), findsOneWidget);

    await tester.tap(find.text('Selesaikan latihan fisika bab gerak').last);
    await tester.pumpAndSettle();
    expect(find.text('Edit tugas'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'Lihat semua'));
    await tester.pumpAndSettle();
    expect(find.text('Semua'), findsOneWidget);
  });

  testWidgets('tugas dapat difilter, dihapus, dan dikembalikan', (
    tester,
  ) async {
    await _setPhoneSize(tester);
    await _openLogin(tester);
    await _login(tester);

    await tester.tap(find.text('Tugas').last);
    await tester.pumpAndSettle();

    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Selesaikan latihan fisika bab gerak'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'Selesai'));
    await tester.pumpAndSettle();

    expect(find.text('Rangkuman ekonomi'), findsOneWidget);
    expect(find.text('Selesaikan latihan fisika bab gerak'), findsNothing);

    await tester.tap(find.byTooltip('Hapus tugas').first);
    await tester.pumpAndSettle();
    expect(find.text('Hapus tugas?'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Hapus tugas?'), findsNothing);

    await tester.tap(find.byTooltip('Hapus tugas').first);
    await tester.pumpAndSettle();
    expect(find.text('Hapus tugas?'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Hapus'));
    await tester.pumpAndSettle();
    expect(find.text('Urungkan'), findsOneWidget);

    await tester.tap(find.text('Urungkan'));
    await tester.pumpAndSettle();
    expect(find.text('Rangkuman ekonomi'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'Proses'));
    await tester.pumpAndSettle();
    expect(find.text('Selesaikan latihan fisika bab gerak'), findsOneWidget);
    expect(find.text('Rangkuman ekonomi'), findsNothing);

    await tester.tap(find.widgetWithText(FilterChip, 'Belum'));
    await tester.pumpAndSettle();
    expect(find.text('Susun esai bahasa Indonesia'), findsOneWidget);
    expect(find.text('Selesaikan latihan fisika bab gerak'), findsNothing);
  });

  testWidgets('tugas baru bisa ditambahkan dari dashboard', (tester) async {
    await _setPhoneSize(tester);
    await _openLogin(tester);
    await _login(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Judul tugas'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Belajar aljabar');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Kerjakan sepuluh soal persamaan linear.',
    );

    await tester.tap(find.widgetWithText(ChoiceChip, 'Tinggi'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Sedang dikerjakan'));
    await tester.pumpAndSettle();

    final saveButton = find.widgetWithText(FilledButton, 'Simpan tugas');
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Tugas baru ditambahkan.'), findsOneWidget);
    expect(find.text('Belajar aljabar'), findsOneWidget);
  });

  testWidgets('tugas bisa diedit dan logout kembali ke login', (tester) async {
    await _setPhoneSize(tester);
    await _openLogin(tester);
    await _login(tester);

    await tester.tap(find.text('Tugas').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Selesaikan latihan fisika bab gerak'));
    await tester.pumpAndSettle();

    expect(find.text('Edit tugas'), findsOneWidget);
    expect(find.text('Selesaikan latihan fisika bab gerak'), findsOneWidget);

    await tester.tap(find.byTooltip('Pilih tenggat'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih tenggat tugas'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Batal'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih tenggat tugas'), findsNothing);

    await tester.tap(find.byTooltip('Pilih tenggat'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih tenggat tugas'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Pilih'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih tenggat tugas'), findsNothing);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Fisika gerak diperbarui',
    );
    await tester.tap(find.widgetWithText(ChoiceChip, 'Selesai'));
    await tester.pumpAndSettle();

    final saveButton = find.widgetWithText(FilledButton, 'Simpan perubahan');
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Perubahan tugas disimpan.'), findsOneWidget);
    expect(find.text('Fisika gerak diperbarui'), findsOneWidget);

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();

    expect(find.text('Rani'), findsOneWidget);
    expect(find.text('rani@sekolah.id'), findsOneWidget);

    final logoutButton = find.widgetWithText(
      OutlinedButton,
      'Keluar dari akun',
    );
    await tester.ensureVisible(logoutButton);
    await tester.pumpAndSettle();
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();
    expect(find.text('Keluar dari akun?'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Keluar dari akun?'), findsNothing);

    await tester.tap(logoutButton);
    await tester.pumpAndSettle();
    expect(find.text('Keluar dari akun?'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Keluar'));
    await tester.pumpAndSettle();

    expect(find.text('Selamat datang kembali'), findsOneWidget);
  });

  testWidgets('empty state muncul dan membuka form tambah', (tester) async {
    await _setPhoneSize(tester);
    await _openLogin(tester);
    await _login(tester);

    await tester.tap(find.text('Tugas').last);
    await tester.pumpAndSettle();

    for (var index = 0; index < 8; index++) {
      await tester.tap(find.byTooltip('Hapus tugas').first);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Hapus'));
      await tester.pumpAndSettle();
    }

    expect(find.text('Belum ada tugas'), findsOneWidget);

    final addButton = find.widgetWithText(FilledButton, 'Tambah tugas');
    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    expect(find.text('Judul tugas'), findsOneWidget);
  });

  testWidgets('layout aman pada layar kecil', (tester) async {
    await _setPhoneSize(tester, size: const Size(320, 640));
    await _openLogin(tester);
    await _login(tester);

    expect(find.text('Ringkasan tugas'), findsOneWidget);

    await tester.tap(find.text('Tugas').last);
    await tester.pumpAndSettle();
    expect(find.text('Semua'), findsOneWidget);

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    expect(
      find.text('Informasi akun dan pengaturan sesi belajar.'),
      findsOneWidget,
    );
  });

  testWidgets('register memvalidasi input lalu kembali ke login', (
    tester,
  ) async {
    await _setPhoneSize(tester);
    await _openLogin(tester);

    await tester.tap(find.widgetWithText(TextButton, 'Daftar'));
    await tester.pumpAndSettle();

    expect(find.text('Buat akun StudyMate'), findsOneWidget);

    final backToLogin = find.widgetWithText(TextButton, 'Masuk');
    await tester.ensureVisible(backToLogin);
    await tester.pumpAndSettle();
    await tester.tap(backToLogin);
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang kembali'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Daftar'));
    await tester.pumpAndSettle();
    expect(find.text('Buat akun StudyMate'), findsOneWidget);

    await tester.tap(find.byTooltip('Tampilkan kata sandi'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Sembunyikan kata sandi'), findsOneWidget);

    await tester.tap(find.byTooltip('Tampilkan konfirmasi kata sandi'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Sembunyikan konfirmasi kata sandi'), findsOneWidget);

    final createButton = find.widgetWithText(FilledButton, 'Buat akun');
    await tester.ensureVisible(createButton);
    await tester.pumpAndSettle();
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    expect(find.text('Nama lengkap wajib diisi.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Rani Prameswari');
    await tester.enterText(find.byType(TextFormField).at(1), 'rani@sekolah.id');
    await tester.enterText(find.byType(TextFormField).at(2), 'rahasia123');
    await tester.enterText(find.byType(TextFormField).at(3), 'rahasia123');

    await tester.ensureVisible(createButton);
    await tester.pumpAndSettle();
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    expect(find.text('Akun demo dibuat. Silakan masuk.'), findsOneWidget);
    expect(find.text('Selamat datang kembali'), findsOneWidget);
    expect(find.text('rani@sekolah.id'), findsOneWidget);
  });
}
