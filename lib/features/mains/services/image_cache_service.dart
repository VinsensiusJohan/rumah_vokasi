import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageCacheService {
  Future<File?> getCourseImage({
    required String courseId,
    required String base64Image,
  }) async {
    if (base64Image.isEmpty) return null;

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/course_$courseId.png');

    if (await file.exists()) {
      return file; // ✅ cache hit
    }

    final bytes = base64Decode(base64Image);
    await file.writeAsBytes(bytes);

    return file;
  }

  Future<void> clear() async {
    final dir = await getTemporaryDirectory();
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }
}
