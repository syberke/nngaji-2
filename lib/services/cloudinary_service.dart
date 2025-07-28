import 'dart:io';
import 'package:dio/dio.dart';
import '../utils/constants.dart';

class CloudinaryService {
  static final Dio _dio = Dio();

  static Future<String> uploadAudio(String filePath) async {
    try {
      final file = File(filePath);
      final fileName = 'hafalan_${DateTime.now().millisecondsSinceEpoch}.m4a';
      
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        'upload_preset': AppConstants.cloudinaryUploadPreset,
        'resource_type': 'video', // Use 'video' for audio files
      });

      final response = await _dio.post(
        '${AppConstants.cloudinaryBaseUrl}/${AppConstants.cloudinaryCloudName}/video/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['secure_url'];
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload audio: ${e.toString()}');
    }
  }

  static Future<bool> deleteFile(String publicId) async {
    try {
      // Note: Deletion requires signed requests in production
      // This is a placeholder for delete functionality
      print('Delete file: $publicId');
      return true;
    } catch (e) {
      print('Cloudinary delete error: $e');
      return false;
    }
  }
}