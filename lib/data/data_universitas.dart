class University {
  final int id;
  final String name;
  final String location;
  final String imageUrl;
  final String speciality;
  final String description;
  final List<String> faculties;
  final List<String> programs;
  final List<String> facilities;
  final bool isFavorite;

  const University({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    this.speciality = '',
    this.description = '',
    this.faculties = const [],
    this.programs = const [],
    this.facilities = const [],
    this.isFavorite = false,
  });
}

const List<University> demoUniversities = [
  University(
    id: 1,
    name: 'Universitas Multi Data Palembang',
    location: 'Jl. Rajawali No. 14, 9 Ilir, Kec. Ilir Tim. II, Kota Palembang 30113, Sumatera Selatan.',
    speciality: 'Teknologi Informasi & Bisnis Digital',
    description:
        'Universitas Multi Data Palembang (UMDP) merupakan perguruan tinggi swasta unggulan di Sumatera Selatan yang berfokus pada bidang teknologi informasi, bisnis digital, dan desain kreatif. Dikenal dengan kurikulum yang modern dan kerja sama industri yang luas.',
    faculties: [
      'Fakultas Ilmu Komputer',
      'Fakultas Ekonomi dan Bisnis',
      'Fakultas Desain dan Seni Kreatif',
    ],
    programs: [
      'Teknik Informatika',
      'Sistem Informasi',
      'Manajemen',
      'Akuntansi',
      'Desain Komunikasi Visual',
    ],
    facilities: [
      'Laboratorium Komputer Modern',
      'Perpustakaan Digital',
      'Studio Desain',
      'Aula Serbaguna',
      'Kantin Sehat',
      'WiFi Berkecepatan Tinggi',
      'Ruang Inkubasi Startup Mahasiswa',
    ],
    imageUrl: 'images/univ_preview/mdp.png',
  ),
  University(
    id: 2,
    name: 'Universitas Sriwijaya',
    location: 'Indralaya & Palembang, Sumatera Selatan',
    speciality: 'Universitas Negeri Terbesar di Sumatera Selatan',
    description:
        'Universitas Sriwijaya (UNSRI) adalah universitas negeri ternama di Sumatera Selatan dengan dua kampus utama di Indralaya dan Palembang. UNSRI dikenal memiliki program studi unggulan di berbagai bidang ilmu.',
    faculties: [
      'Fakultas Ekonomi',
      'Fakultas Hukum',
      'Fakultas Teknik',
      'Fakultas Kedokteran',
      'Fakultas Ilmu Sosial dan Ilmu Politik',
      'Fakultas Pertanian',
    ],
    programs: [
      'Akuntansi',
      'Manajemen',
      'Teknik Sipil',
      'Kedokteran',
      'Ilmu Komunikasi',
      'Agroteknologi',
    ],
    facilities: [
      'Rumah Sakit Pendidikan',
      'Perpustakaan Pusat',
      'Laboratorium Penelitian',
      'Asrama Mahasiswa',
      'Bus Kampus Gratis',
      'Fasilitas Olahraga',
    ],
    imageUrl: 'images/univ_preview/unsri.png',
  ),
  University(
    id: 3,
    name: 'Universitas Bina Darma',
    location: 'Palembang, Sumatera Selatan',
    speciality: 'Teknologi, Ekonomi, dan Pendidikan',
    description:
        'Universitas Bina Darma merupakan universitas swasta yang berfokus pada pendidikan teknologi, bisnis, dan ilmu sosial. Kampus ini aktif dalam kegiatan penelitian dan inovasi di bidang digital.',
    faculties: [
      'Fakultas Ilmu Komputer',
      'Fakultas Ekonomi dan Bisnis',
      'Fakultas Keguruan dan Ilmu Pendidikan',
    ],
    programs: [
      'Teknik Informatika',
      'Manajemen',
      'Pendidikan Bahasa Inggris',
      'Sistem Informasi',
      'Akuntansi',
    ],
    facilities: [
      'Laboratorium Komputer',
      'Perpustakaan Digital',
      'Aula Auditorium',
      'Studio Multimedia',
      'Ruang Belajar Interaktif',
    ],
    imageUrl: 'images/univ_preview/ubd.png',
  ),
  University(
    id: 4,
    name: 'Universitas Muhammadiyah Palembang',
    location: 'Palembang, Sumatera Selatan',
    speciality: 'Pendidikan, Teknik, dan Hukum',
    description:
        'Universitas Muhammadiyah Palembang adalah universitas swasta berbasis Islam yang memiliki visi menghasilkan lulusan berakhlak mulia, profesional, dan kompetitif.',
    faculties: [
      'Fakultas Teknik',
      'Fakultas Ekonomi dan Bisnis',
      'Fakultas Hukum',
      'Fakultas Agama Islam',
      'Fakultas Keguruan dan Ilmu Pendidikan',
    ],
    programs: [
      'Teknik Sipil',
      'Hukum',
      'Ekonomi Syariah',
      'Pendidikan Biologi',
      'Manajemen',
    ],
    facilities: [
      'Masjid Kampus',
      'Laboratorium Hukum',
      'Perpustakaan Digital',
      'Lapangan Olahraga',
      'Asrama Mahasiswa',
    ],
    imageUrl: 'images/univ_preview/umpalembang.png',
  ),
  University(
    id: 5,
    name: 'Universitas Katolik Musi Charitas',
    location: 'Palembang, Sumatera Selatan',
    speciality: 'Kesehatan dan Ilmu Sosial',
    description:
        'Universitas Katolik Musi Charitas merupakan perguruan tinggi swasta yang unggul di bidang kesehatan, psikologi, dan pendidikan. Kampus ini dikenal memiliki lingkungan akademik yang disiplin dan nyaman.',
    faculties: [
      'Fakultas Kesehatan',
      'Fakultas Psikologi',
      'Fakultas Ekonomi',
      'Fakultas Pendidikan',
    ],
    programs: [
      'Keperawatan',
      'Farmasi',
      'Psikologi',
      'Manajemen',
      'Pendidikan Guru SD',
    ],
    facilities: [
      'Rumah Sakit Pendidikan',
      'Laboratorium Medis',
      'Perpustakaan',
      'Klinik Kampus',
      'Asrama Mahasiswa',
    ],
    imageUrl: 'images/univ_preview/unika.png',
  ),
  University(
    id: 6,
    name: 'Universitas IGM (Indo Global Mandiri)',
    location: 'Palembang, Sumatera Selatan',
    speciality: 'Teknologi & Bisnis Modern',
    description:
        'Universitas Indo Global Mandiri berfokus pada pengembangan teknologi digital dan bisnis modern. Kampus ini memiliki fasilitas pembelajaran berbasis IT dan koneksi industri yang luas.',
    faculties: [
      'Fakultas Ilmu Komputer',
      'Fakultas Ekonomi',
      'Fakultas Teknik',
    ],
    programs: [
      'Sistem Informasi',
      'Teknik Informatika',
      'Manajemen',
      'Teknik Industri',
    ],
    facilities: [
      'Smart Classroom',
      'Lab Komputer',
      'Aula Serbaguna',
      'Perpustakaan Digital',
    ],
    imageUrl: 'images/univ_preview/igm.png',
  ),
  University(
    id: 7,
    name: 'Universitas Tridinanti Palembang',
    location: 'Palembang, Sumatera Selatan',
    speciality: 'Teknik dan Ekonomi',
    description:
        'Universitas Tridinanti Palembang (UTP) memiliki fokus pada bidang teknik dan ekonomi. Kampus ini aktif dalam kegiatan sosial dan pengabdian masyarakat.',
    faculties: [
      'Fakultas Teknik',
      'Fakultas Ekonomi',
      'Fakultas Hukum',
    ],
    programs: [
      'Teknik Sipil',
      'Teknik Mesin',
      'Akuntansi',
      'Manajemen',
      'Hukum Bisnis',
    ],
    facilities: [
      'Laboratorium Teknik',
      'Ruang Seminar',
      'Kantin',
      'Perpustakaan',
      'Lapangan Futsal',
    ],
    imageUrl: 'images/univ_preview/tridinanti.png',
  ),
  University(
    id: 8,
    name: 'Politeknik Negeri Sriwijaya',
    location: 'Palembang, Sumatera Selatan',
    speciality: 'Pendidikan Vokasi Terapan',
    description:
        'Politeknik Negeri Sriwijaya (Polsri) adalah kampus vokasi negeri yang menghasilkan lulusan siap kerja di bidang teknik dan bisnis.',
    faculties: [
      'Jurusan Teknik Elektro',
      'Jurusan Akuntansi',
      'Jurusan Teknik Komputer',
      'Jurusan Administrasi Bisnis',
    ],
    programs: [
      'D4 Teknik Elektro',
      'D3 Akuntansi',
      'D3 Administrasi Bisnis',
      'D4 Teknik Komputer',
    ],
    facilities: [
      'Workshop Industri',
      'Laboratorium Praktikum',
      'Perpustakaan',
      'Kantin',
      'Gedung Serbaguna',
    ],
    imageUrl: 'images/univ_preview/polsri.jpg',
  ),
  University(
    id: 9,
    name: 'Universitas PGRI Palembang',
    location: 'Palembang, Sumatera Selatan',
    speciality: 'Keguruan & Pendidikan',
    description:
        'Universitas PGRI Palembang fokus pada pendidikan guru dan pengembangan sumber daya manusia di bidang pendidikan. Kampus ini memiliki reputasi kuat dalam mencetak tenaga pendidik profesional.',
    faculties: [
      'Fakultas Keguruan dan Ilmu Pendidikan',
      'Fakultas Ekonomi dan Bisnis',
      'Fakultas Teknik',
    ],
    programs: [
      'Pendidikan Bahasa Inggris',
      'Pendidikan Matematika',
      'Manajemen',
      'Teknik Sipil',
    ],
    facilities: [
      'Ruang Micro Teaching',
      'Perpustakaan Digital',
      'Asrama Mahasiswa',
      'Lapangan Olahraga',
    ],
    imageUrl: 'images/univ_preview/pgri.png',
  ),
  University(
    id: 10,
    name: 'Universitas Islam Negeri Raden Fatah Palembang',
    location: 'Palembang, Sumatera Selatan',
    speciality: 'Pendidikan Islam dan Humaniora',
    description:
        'UIN Raden Fatah Palembang adalah perguruan tinggi Islam negeri tertua di Sumatera Selatan yang menggabungkan nilai-nilai Islam dengan ilmu pengetahuan modern.',
    faculties: [
      'Fakultas Syariah dan Hukum',
      'Fakultas Dakwah dan Komunikasi',
      'Fakultas Ekonomi dan Bisnis Islam',
      'Fakultas Sains dan Teknologi',
    ],
    programs: [
      'Hukum Islam',
      'Komunikasi Penyiaran Islam',
      'Ekonomi Syariah',
      'Teknik Informatika',
    ],
    facilities: [
      'Masjid Raya Kampus',
      'Laboratorium Bahasa',
      'Perpustakaan Modern',
      'Asrama Putra Putri',
      'Kantin Halal',
    ],
    imageUrl: 'images/univ_preview/uirf.png',
  ),
];


