class University {
  final int id;
  final String name;
  final String location;
  final String imageUrl;
  final String speciality;
  final String description;
  final bool isFavorite;

  const University({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    this.speciality = '',
    this.description = '',
    this.isFavorite = false,
  });
}

const List<University> demoUniversities = [
  University(
    id: 1,
    name: 'Universitas Indonesia',
    location: 'Depok, Jawa Barat',
    speciality: 'Kedokteran & Ilmu Sosial terbaik',
    description:
        'Universitas Indonesia adalah perguruan tinggi negeri terkemuka di Indonesia yang dikenal dengan program studi kedokteran dan ilmu sosial yang unggul. Kampus ini memiliki fasilitas lengkap dan dosen berpengalaman.',
    imageUrl:
        'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=720&q=80',
    isFavorite: true,
  ),
  University(
    id: 2,
    name: 'Institut Teknologi Bandung',
    location: 'Bandung, Jawa Barat',
    speciality: 'Teknik & Sains teratas',
    description:
        'Institut Teknologi Bandung merupakan perguruan tinggi teknik terbaik di Indonesia yang menghasilkan lulusan berkualitas tinggi di bidang teknik dan sains. Kampus ini memiliki tradisi akademik yang kuat dan banyak menghasilkan inovator.',
    imageUrl:
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=720&q=80',
  ),
  University(
    id: 3,
    name: 'Universitas Gadjah Mada',
    location: 'Yogyakarta, DIY',
    speciality: 'Riset multidisiplin unggulan',
    description:
        'Universitas Gadjah Mada adalah universitas negeri terkemuka yang dikenal dengan pendekatan riset multidisiplin. Kampus ini menawarkan berbagai program studi dengan kualitas tinggi dan lingkungan akademik yang mendukung perkembangan mahasiswa.',
    imageUrl:
        'https://images.unsplash.com/photo-1503676382389-4809596d5290?auto=format&fit=crop&w=720&q=80',
    isFavorite: true,
  ),
  University(
    id: 4,
    name: 'Institut Pertanian Bogor',
    location: 'Bogor, Jawa Barat',
    speciality: 'Agrokompleks dan lingkungan',
    description:
        'Institut Pertanian Bogor adalah perguruan tinggi unggulan di bidang pertanian, agrokompleks, dan lingkungan. Kampus ini memiliki keahlian khusus dalam pengembangan teknologi pertanian dan pelestarian lingkungan.',
    imageUrl:
        'https://images.unsplash.com/photo-1533228100845-08145b01de14?auto=format&fit=crop&w=720&q=80',
  ),
  University(
    id: 5,
    name: 'Universitas Airlangga',
    location: 'Surabaya, Jawa Timur',
    speciality: 'Kesehatan & bisnis kompetitif',
    description:
        'Universitas Airlangga adalah universitas negeri yang unggul di bidang kesehatan dan bisnis. Kampus ini memiliki fakultas kedokteran dan manajemen yang sangat kompetitif dengan program studi yang relevan dengan kebutuhan industri.',
    imageUrl:
        'https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d?auto=format&fit=crop&w=720&q=80',
  ),
  University(
    id: 6,
    name: 'Binus University',
    location: 'Jakarta, DKI Jakarta',
    speciality: 'Teknologi & bisnis modern',
    description:
        'Binus University adalah universitas swasta terkemuka yang fokus pada teknologi dan bisnis modern. Kampus ini dikenal dengan program studi teknologi informasi dan manajemen bisnis yang mengikuti perkembangan zaman.',
    imageUrl:
        'https://images.unsplash.com/photo-1513258496099-48168024aec0?auto=format&fit=crop&w=720&q=80',
  ),
];

