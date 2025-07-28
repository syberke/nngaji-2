import 'package:flutter/material.dart';
import '../models/setoran_model.dart';
import '../services/setoran_service.dart';

class SetoranProvider with ChangeNotifier {
  final SetoranService _setoranService = SetoranService();
  
  List<SetoranModel> _setoranList = [];
  bool _isLoading = false;
  String? _error;

  List<SetoranModel> get setoranList => _setoranList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSetoranBySiswa(String siswaId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _setoranList = await _setoranService.getSetoranBySiswa(siswaId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSetoranByGuru(String guruId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _setoranList = await _setoranService.getSetoranByGuru(guruId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitSetoran({
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
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _setoranService.createSetoran(
        siswaId: siswaId,
        guruId: guruId,
        organizeId: organizeId,
        fileUrl: fileUrl,
        jenis: jenis,
        surah: surah,
        juz: juz,
        catatan: catatan,
      );

      if (success) {
        // Refresh the list
        await fetchSetoranBySiswa(siswaId);
      }

      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateSetoranStatus(
    String setoranId,
    SetoranStatus status, {
    String? catatan,
    int? poin,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _setoranService.updateSetoranStatus(
        setoranId,
        status,
        catatan: catatan,
        poin: poin,
      );

      if (success) {
        // Update local list
        final index = _setoranList.indexWhere((s) => s.id == setoranId);
        if (index != -1) {
          // This would require updating the model, simplified for now
          // _setoranList[index] = _setoranList[index].copyWith(status: status);
        }
      }

      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}