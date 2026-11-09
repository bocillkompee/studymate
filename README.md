# StudyMate

Aplikasi Flutter untuk pelajar yang mencatat tugas, tenggat, prioritas, status pengerjaan, dan progres belajar dalam satu tempat.

Status saat ini: prototipe frontend. Data tugas masih berasal dari data contoh di memori dan autentikasi belum tersambung ke server. Bagian [Mode demo dan batasan](#mode-demo-dan-batasan) menjelaskan apa yang sudah berjalan dan apa yang belum.

## Fitur

- Splash screen yang mengarah ke halaman masuk setelah 1,8 detik.
- Masuk dan daftar akun dengan validasi email, kata sandi, dan konfirmasi kata sandi.
- Dashboard berisi sapaan, tanggal hari ini, tugas terdekat, ringkasan jumlah tugas per status, dan tiga tugas terbaru.
- Daftar tugas dengan filter status: Semua, Belum, Proses, Selesai.
- Tambah, edit, dan hapus tugas. Penghapusan bisa dibatalkan lewat tombol Urungkan pada snackbar.
- Form tugas berisi judul, deskripsi, tenggat lewat date picker, prioritas (Rendah, Sedang, Tinggi), dan status.
- Profil berisi inisial nama, email, status akun demo, jumlah tugas, dan tombol keluar dengan konfirmasi.
- Empty state, loading state, error state, dan pull to refresh pada dashboard serta daftar tugas.
- Tema Material 3 dengan locale Indonesia.

## Teknologi

- Flutter 3.44.7 stable dengan Dart 3.12.2.
- `flutter_localizations` untuk format tanggal dan teks Indonesia.
- `flutter_lints` untuk aturan lint.

## Struktur proyek

```text
lib/
  main.dart
  models/          Task dan User
  screens/
    auth/          Splash, login, register
    dashboard/     Ringkasan tugas
    tasks/         Daftar dan form tugas
    profile/       Profil dan logout
  services/        AppState, service API, data contoh
  utils/           Warna, tema, routing, format tanggal, spacing
  widgets/         Komponen yang dipakai lintas layar
test/
  widget_test.dart
```

## Menjalankan

Prasyarat: Flutter stable 3.44 atau lebih baru.

```bash
flutter pub get
flutter run
```

Perintah pemeriksaan:

```bash
flutter analyze
flutter test
```

## Konfigurasi API

`ApiClient` membaca `API_BASE_URL` dengan nilai default `http://localhost:8080/api`.

```bash
# Chrome atau desktop
flutter run --dart-define=API_BASE_URL=http://localhost:8080/api

# Emulator Android
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/api
```

## Mode demo dan batasan

- Login menerima email dan kata sandi apa pun yang lolos validasi form, tanpa pengecekan ke server.
- Pendaftaran akun hanya mengingat nama dan email selama aplikasi berjalan.
- Tugas awal berasal dari `lib/services/mock_data.dart`.
- Tambah, edit, dan hapus tugas hanya mengubah state di memori, lalu hilang saat aplikasi ditutup.
- Pemanggilan REST API belum aktif. Bagian yang menunggu backend ditandai `TODO(API)` di `lib/services/api_client.dart`, `lib/services/auth_service.dart`, `lib/services/task_service.dart`, dan `lib/services/app_state.dart`.

## Rencana integrasi backend

- `POST /auth/login` dan `POST /auth/register`, lalu simpan token JWT.
- `GET /tasks`, `POST /tasks`, `PUT /tasks/{id}`, dan `DELETE /tasks/{id}` dengan header `Authorization: Bearer <JWT>`.
- Ganti `MockData` dengan respons server dan tangani status loading serta error dari jaringan.
