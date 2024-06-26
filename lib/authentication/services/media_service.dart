import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();

  MediaService();

  Future<File?> getImageFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        return File(file.path);
      } else {
        // User canceled image picking
        return null;
      }
    } catch (e) {
      // Handle errors
      print('Error picking image: $e');
      return null;
    }
  }
}
