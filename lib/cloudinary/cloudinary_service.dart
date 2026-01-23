import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final cloudinary = CloudinaryPublic('dpufywjjt', 'dog_care', cache: false);

  Future<String> uploadImage(File file) async {
    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        file.path,
        resourceType: CloudinaryResourceType.Image,
      ),
    );
    return response.secureUrl;
  }

  Future<String> uploadVideo(File file) async {
    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        file.path,
        resourceType: CloudinaryResourceType.Video,
      ),
    );
    return response.secureUrl;
  }
}
