# Project_Akhir_PAB

## Deskripsi Proyek
Aplikasi ini merupakan contoh implementasi Flutter dengan fitur:

* **Pencarian (Search Filter)** berbasis query secara real-time.
* **Daftar Favorit (Favorites)** dengan penyimpanan data lokal menggunakan **SQLite**.
* **Profil Pengguna (Profile Screen)** yang dapat mengedit nama dan foto pengguna.

Semua fitur dirancang menggunakan pendekatan **Material Design 3** dan mengikuti praktik terbaik dari dokumentasi resmi Flutter.

## Fitur Utama
1. **Login (Login Screen)**
   Halaman untuk login pengguna dengan username dan password.

2. **Beranda (Home Screen)**
   Menampilkan daftar kartu berisi data barang dengan gambar dummy, nama, dan deskripsi.

   * Tombol **Detail** untuk menampilkan deskripsi secara collapse/expand.
   * Tombol **Checkbox Favorit** untuk menandai item sebagai favorit dan menyimpannya ke basis data SQLite.
   * **Kolom pencarian (TextField)** untuk mencari barang berdasarkan nama atau deskripsi secara langsung (real-time).

2. **Menu Favorit (Favorites Screen)**
   Menampilkan hanya barang yang telah ditandai sebagai favorit.
   Data otomatis diperbarui jika pengguna menambah atau menghapus tanda favorit di beranda.

3. **Profil (Profile Screen)**
   Halaman untuk mengedit nama pengguna dan mengubah foto profil dengan mengambil gambar dari galeri perangkat.
   Semua perubahan disimpan secara permanen di SQLite.

## Teknologi yang Digunakan

* **Flutter SDK ≥ 3.4.0**
* **Bahasa pemrograman**: Dart
* **Paket utama**:

  * `flutter_riverpod` — untuk manajemen state
  * `sqflite` dan `path` — untuk penyimpanan data lokal
  * `image_picker` — untuk pengambilan gambar dari galeri
  * `equatable` — untuk value equality

## Struktur Proyek

```
lib/
  main.dart
```

## Inisialisasi Proyek

Proyek ini diinisialisasi berdasarkan dokumentasi resmi Flutter di [https://api.flutter.dev/](https://api.flutter.dev/), dengan mengikuti prinsip dan praktik langsung dari dokumentasi Flutter terkini.

Untuk menjalankan proyek ini:

```bash
flutter pub get
flutter run
```

## Tujuan Pembelajaran

Proyek ini bertujuan untuk:

* Meningkatkan pemahaman tentang **pengelolaan state dan data lokal** menggunakan Riverpod dan SQLite.
* Mengimplementasikan **pencarian real-time** dan **pengelolaan data dinamis** di Flutter.
* Mempraktikkan **desain antarmuka responsif** berbasis Material 3.

---

© 2025 — Disusun oleh<br>
**M. Rizki Algipari**<br>
**Yonathan Rinfi**<br>
**Daniel Linpa Ganata**
# PAB_Wisata_Candi
