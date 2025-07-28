import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../providers/auth_provider.dart';
import '../../providers/setoran_provider.dart';
import '../../models/setoran_model.dart';
import '../../services/cloudinary_service.dart';
import '../../utils/theme.dart';
import '../../utils/constants.dart';

class UploadSetoranScreen extends StatefulWidget {
  const UploadSetoranScreen({super.key});

  @override
  State<UploadSetoranScreen> createState() => _UploadSetoranScreenState();
}

class _UploadSetoranScreenState extends State<UploadSetoranScreen> {
  final _formKey = GlobalKey<FormState>();
  final _surahController = TextEditingController();
  final _catatanController = TextEditingController();
  final _record = AudioRecorder();
  final _audioPlayer = AudioPlayer();

  SetoranJenis _selectedJenis = SetoranJenis.hafalan;
  int? _selectedJuz;
  String? _recordingPath;
  String? _selectedFilePath;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isUploading = false;
  Duration _recordingDuration = Duration.zero;

  @override
  void dispose() {
    _surahController.dispose();
    _catatanController.dispose();
    _record.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> _startRecording() async {
    try {
      await _requestPermissions();
      
      if (await _record.hasPermission()) {
        final path = '/tmp/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _record.start(const RecordConfig(), path: path);
        
        setState(() {
          _isRecording = true;
          _recordingPath = path;
          _selectedFilePath = null;
          _recordingDuration = Duration.zero;
        });

        // Start timer
        _startTimer();
      }
    } catch (e) {
      _showError('Gagal memulai recording: $e');
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording) {
        setState(() {
          _recordingDuration = _recordingDuration + const Duration(seconds: 1);
        });
        _startTimer();
      }
    });
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _record.stop();
      setState(() {
        _isRecording = false;
        _recordingPath = path;
      });
    } catch (e) {
      _showError('Gagal menghentikan recording: $e');
    }
  }

  Future<void> _playRecording() async {
    if (_recordingPath == null && _selectedFilePath == null) return;

    try {
      final filePath = _recordingPath ?? _selectedFilePath!;
      
      if (_isPlaying) {
        await _audioPlayer.stop();
        setState(() {
          _isPlaying = false;
        });
      } else {
        await _audioPlayer.play(DeviceFileSource(filePath));
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      _showError('Gagal memutar audio: $e');
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFilePath = result.files.single.path;
          _recordingPath = null;
        });
      }
    } catch (e) {
      _showError('Gagal memilih file: $e');
    }
  }

  Future<void> _submitSetoran() async {
    if (!_formKey.currentState!.validate()) return;
    
    final filePath = _recordingPath ?? _selectedFilePath;
    if (filePath == null) {
      _showError('Pilih file audio atau rekam terlebih dahulu');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload to Cloudinary
      final fileUrl = await CloudinaryService.uploadAudio(filePath);
      
      // Get user data
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user!;
      
      // Submit setoran
      final success = await Provider.of<SetoranProvider>(context, listen: false)
          .submitSetoran(
        siswaId: user.id,
        guruId: user.organizeId!, // Assuming organize has guru
        organizeId: user.organizeId!,
        fileUrl: fileUrl,
        jenis: _selectedJenis,
        surah: _surahController.text.trim(),
        juz: _selectedJuz,
        catatan: _catatanController.text.trim().isEmpty 
            ? null 
            : _catatanController.text.trim(),
      );

      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Setoran berhasil dikirim!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      } else {
        _showError('Gagal mengirim setoran');
      }
    } catch (e) {
      _showError('Gagal upload: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorRed,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Setoran'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Jenis Setoran
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jenis Setoran',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<SetoranJenis>(
                            title: const Text('Hafalan'),
                            value: SetoranJenis.hafalan,
                            groupValue: _selectedJenis,
                            onChanged: (value) {
                              setState(() {
                                _selectedJenis = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<SetoranJenis>(
                            title: const Text('Murojaah'),
                            value: SetoranJenis.murojaah,
                            groupValue: _selectedJenis,
                            onChanged: (value) {
                              setState(() {
                                _selectedJenis = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Surah dan Juz
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _surahController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Surah *',
                        hintText: 'Contoh: Al-Fatihah',
                        prefixIcon: Icon(Icons.book),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama surah tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedJuz,
                      decoration: const InputDecoration(
                        labelText: 'Juz (Opsional)',
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      items: List.generate(30, (index) => index + 1)
                          .map((juz) => DropdownMenuItem(
                                value: juz,
                                child: Text('Juz $juz'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedJuz = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Audio Recording/Upload
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audio Setoran',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Recording Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            FloatingActionButton(
                              onPressed: _isRecording ? _stopRecording : _startRecording,
                              backgroundColor: _isRecording 
                                  ? AppTheme.errorRed 
                                  : AppTheme.primaryGreen,
                              child: Icon(
                                _isRecording ? Icons.stop : Icons.mic,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isRecording ? 'Stop' : 'Rekam',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            FloatingActionButton(
                              onPressed: _pickFile,
                              backgroundColor: AppTheme.secondaryBlue,
                              child: const Icon(
                                Icons.file_upload,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Upload',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        if (_recordingPath != null || _selectedFilePath != null)
                          Column(
                            children: [
                              FloatingActionButton(
                                onPressed: _playRecording,
                                backgroundColor: AppTheme.accentGold,
                                child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isPlaying ? 'Pause' : 'Play',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                      ],
                    ),

                    if (_isRecording) ...[
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Recording: ${_formatDuration(_recordingDuration)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.errorRed,
                          ),
                        ),
                      ),
                    ],

                    if (_recordingPath != null || _selectedFilePath != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.successGreen.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppTheme.successGreen,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text('Audio siap untuk diupload'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Catatan
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: _catatanController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Catatan (Opsional)',
                    hintText: 'Tambahkan catatan jika diperlukan...',
                    prefixIcon: Icon(Icons.note),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _isUploading ? null : _submitSetoran,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isUploading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Mengupload...'),
                      ],
                    )
                  : const Text('Kirim Setoran'),
            ),
          ],
        ),
      ),
    );
  }
}