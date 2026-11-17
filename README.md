# jembergo_mobile_app

A new Flutter project.

## Struktur `lib/`

- `features/` mengelompokkan layar menurut alur aplikasi: `auth`, `home`,
  `destination`, `booking`, `payment`, `ticket`, `map`, dan `profile`.
- `core/` berisi konfigurasi umum, tema, dan API client.
- `models/` menyimpan model destinasi, profil, tiket, dan artikel.
- `services/` berisi layanan khusus seperti estimasi rute.
- `shared/widgets/` menampung widget yang dipakai beberapa fitur.
- `app.dart` menyusun root aplikasi; `main.dart` menjadi titik masuk.

Struktur ini memisahkan fitur dan kode bersama, tanpa menambahkan layer
controller, repository, atau domain sebelum memang dibutuhkan. Login dan
register saat ini masih berupa UI, belum autentikasi backend.

### Menjalankan dengan API

Alamat API diberikan saat menjalankan aplikasi, bukan ditulis permanen di kode:

```sh
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000/api/
```

Sesuaikan host, port, dan path dengan backend yang digunakan.
`ApiService` di `core/network/api_service.dart` menyediakan request JSON, token
Bearer opsional, dan error API. Endpoint fitur bisa ditambahkan setelah kontrak
API dari backend tersedia. Untuk Flutter Web, server API juga perlu mengizinkan
origin aplikasi melalui CORS.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
