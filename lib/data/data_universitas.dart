class University {
  final int id;
  final String name;
  final String location;
  final String imageUrl;
  final String speciality;
  final String description;
  final bool isFavorite;
  final bool isAsset;

  const University({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    this.speciality = '',
    this.description = '',
    this.isFavorite = false,
    this.isAsset = false,
  });
}

const List<University> demoUniversities = [
  University(
    id: 1,
    name: 'Universitas Multi Data Palembang',
    location: 'Palembang, Sumatera Selatan',
    speciality: 'Teknik, Kedokteran & Agribisnis unggulan',
    description:
        'Universitas Multi Data Palembang (MDP) adalah perguruan tinggi swasta di Sumatera Selatan yang berfokus pada bidang teknologi informasi, bisnis, dan desain. Kampus ini dikenal dengan pendekatan pembelajaran praktis, kurikulum berbasis industri, serta kerjasama luas dengan perusahaan teknologi nasional. MDP juga menjadi pelopor pendidikan berbasis digital di Palembang dengan berbagai fasilitas modern seperti laboratorium komputer, inkubator startup, dan pusat inovasi mahasiswa.:contentReference[oaicite:0]{index=0}',
    imageUrl: 'images/univ_preview/mdp.png',
    isAsset: true,
  ),
  University(
    id: 2,
    name: 'Universitas Bina Darma',
    location: 'Palembang, Sumatera Selatan',
    speciality: 'Teknologi Informasi & Komunikasi modern',
    description:
        'Universitas Bina Darma (UBD) adalah universitas swasta di Palembang yang fokus pada teknologi informasi, komunikasi, dan vokasi, dengan berbagai fakultas teknik & humaniora. :contentReference[oaicite:1]{index=1}',
    imageUrl:
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=720&q=80',
  ),
  University(
    id: 3,
    name: 'Universitas Islam Negeri Raden Fatah',
    location: 'Palembang, Sumatera Selatan',
    speciality: 'Ilmu Sosial Islam & Teknologi',
    description:
        'Universitas Islam Negeri (UIN) Raden Fatah Palembang awalnya IAIN dan kini menjadi universitas negeri yang menggabungkan studi agama Islam dan ilmu umum.',
    imageUrl:
        'https://images.unsplash.com/photo-1503676382389-4809596d5290?auto=format&fit=crop&w=720&q=80',
  ),
  University(
    id: 4,
    name: 'Universitas Muhammadiyah Palembang',
    location: 'Palembang, Sumatera Selatan',
    speciality: 'Unggul & Islami – Kesehatan & Teknik',
    description:
        'Universitas Muhammadiyah Palembang (UMP) adalah universitas swasta besar di Sumsel dengan slogan “Unggul & Islami”, memiliki berbagai program studi termasuk kesehatan dan teknik.',
    imageUrl:
        'https://images.unsplash.com/photo-1533228100845-08145b01de14?auto=format&fit=crop&w=720&q=80',
  ),
  University(
    id: 5,
    name: 'Universitas Sumatera Selatan',
    location: 'Palembang, Sumatera Selatan',
    speciality: 'Sains, Teknologi & Humaniora relevan zaman',
    description:
        'Universitas Sumatera Selatan (USS) berdiri pada tahun 2019 di Palembang, fokus pada pendidikan tinggi yang berkualitas di bidang sains, teknologi, dan humaniora.',
    imageUrl:
        'https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d?auto=format&fit=crop&w=720&q=80',
  ),
];
