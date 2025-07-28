enum SetoranJenis { hafalan, murojaah }

enum SetoranStatus { pending, diterima, ditolak, selesai }

class SetoranModel {
  final String id;
  final String siswaId;
  final String guruId;
  final String organizeId;
  final String fileUrl;
  final SetoranJenis jenis;
  final DateTime tanggal;
  final SetoranStatus status;
  final String? catatan;
  final String? surah;
  final int? juz;
  final int poin;
  final DateTime createdAt;

  SetoranModel({
    required this.id,
    required this.siswaId,
    required this.guruId,
    required this.organizeId,
    required this.fileUrl,
    required this.jenis,
    required this.tanggal,
    required this.status,
    this.catatan,
    this.surah,
    this.juz,
    required this.poin,
    required this.createdAt,
  });

  factory SetoranModel.fromJson(Map<String, dynamic> json) {
    return SetoranModel(
      id: json['id'],
      siswaId: json['siswa_id'],
      guruId: json['guru_id'],
      organizeId: json['organize_id'],
      fileUrl: json['file_url'],
      jenis: SetoranJenis.values.firstWhere(
        (e) => e.name == json['jenis'],
        orElse: () => SetoranJenis.hafalan,
      ),
      tanggal: DateTime.parse(json['tanggal']),
      status: SetoranStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SetoranStatus.pending,
      ),
      catatan: json['catatan'],
      surah: json['surah'],
      juz: json['juz'],
      poin: json['poin'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'siswa_id': siswaId,
      'guru_id': guruId,
      'organize_id': organizeId,
      'file_url': fileUrl,
      'jenis': jenis.name,
      'tanggal': tanggal.toIso8601String().split('T')[0],
      'status': status.name,
      'catatan': catatan,
      'surah': surah,
      'juz': juz,
      'poin': poin,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get jenisDisplayName {
    switch (jenis) {
      case SetoranJenis.hafalan:
        return 'Hafalan';
      case SetoranJenis.murojaah:
        return 'Murojaah';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case SetoranStatus.pending:
        return 'Menunggu Review';
      case SetoranStatus.diterima:
        return 'Diterima';
      case SetoranStatus.ditolak:
        return 'Ditolak';
      case SetoranStatus.selesai:
        return 'Selesai';
    }
  }
}