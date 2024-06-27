import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VideoService {
  final ImagePicker _picker = ImagePicker();
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<File?> pickVideoFromGallery() async {
    final XFile? videoFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (videoFile != null) {
      return File(videoFile.path);
    }
    return null;
  }

  Future<String?> uploadVideo(File video) async {
    try {
      final String filePath = 'public/videos/${DateTime.now().millisecondsSinceEpoch}.mp4';
      final response = await _supabaseClient.storage
          .from('videos')
          .upload(filePath, video);
        return filePath;
    } catch (e) {
      print('Error uploading video: $e');
    }
    return null;
  }
}

