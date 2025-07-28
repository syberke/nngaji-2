import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/setoran_model.dart';
import '../utils/constants.dart';

class SetoranService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<SetoranModel>> getSetoranBySiswa(String siswaId) async {
    try {
      final response = await _supabase
          .from('setoran')
          .select()
          .eq('siswa_id', siswaId)
          .order('created_at', ascending: false);

      return response.map<SetoranModel>((json) => SetoranModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch setoran: ${e.toString()}');
    }
  }

  Future<List<SetoranModel>> getSetoranByGuru(String guruId) async {
    try {
      final response = await _supabase
          .from('setoran')
          .select()
          .eq('guru_id', guruId)
          .order('created_at', ascending: false);

      return response.map<SetoranModel>((json) => SetoranModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch setoran: ${e.toString()}');
    }
  }

  Future<bool> createSetoran({
    required String siswaId,
    required String guruId,
    required String organizeId,
    required String fileUrl,
    required SetoranJenis jenis,
    required String surah,
    int? juz,
    String? catatan,
  }) async {
    try {
      await _supabase.from('setoran').insert({
        'siswa_id': siswaId,
        'guru_id': guruId,
        'organize_id': organizeId,
        'file_url': fileUrl,
        'jenis': jenis.name,
        'tanggal': DateTime.now().toIso8601String().split('T')[0],
        'surah': surah,
        'juz': juz,
        'catatan': catatan,
        'poin': jenis == SetoranJenis.hafalan 
            ? AppConstants.hafalanPoints 
            : AppConstants.murojaahPoints,
      });
      return true;
    } catch (e) {
      throw Exception('Failed to create setoran: ${e.toString()}');
    }
  }

  Future<bool> updateSetoranStatus(
    String setoranId,
    SetoranStatus status, {
    String? catatan,
    int? poin,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'status': status.name,
      };

      if (catatan != null) updateData['catatan'] = catatan;
      if (poin != null) updateData['poin'] = poin;

      await _supabase
          .from('setoran')
          .update(updateData)
          .eq('id', setoranId);

      // If accepted, update student points
      if (status == SetoranStatus.diterima && poin != null) {
        await _updateStudentPoints(setoranId, poin);
      }

      return true;
    } catch (e) {
      throw Exception('Failed to update setoran: ${e.toString()}');
    }
  }

  Future<void> _updateStudentPoints(String setoranId, int points) async {
    try {
      // Get setoran details
      final setoran = await _supabase
          .from('setoran')
          .select('siswa_id')
          .eq('id', setoranId)
          .single();

      final siswaId = setoran['siswa_id'];

      // Check if student points record exists
      final existingPoints = await _supabase
          .from('siswa_poin')
          .select()
          .eq('siswa_id', siswaId)
          .maybeSingle();

      if (existingPoints != null) {
        // Update existing points
        await _supabase
            .from('siswa_poin')
            .update({
              'total_poin': existingPoints['total_poin'] + points,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('siswa_id', siswaId);
      } else {
        // Create new points record
        await _supabase.from('siswa_poin').insert({
          'siswa_id': siswaId,
          'total_poin': points,
        });
      }
    } catch (e) {
      // Log error but don't throw to avoid breaking the main operation
      print('Failed to update student points: $e');
    }
  }
}