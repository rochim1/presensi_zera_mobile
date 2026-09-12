import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart';

extension XFileMultipartExtension on XFile {
  Future<MultipartFile> toCompressedMultipart({
    String fieldName = 'file',
    int quality = 80,
    int minWidth = 1080,
    int minHeight = 1080,
    String? filename,
  }) async {
    final fileName = filename ?? name;

    if (_isImage(fileName)) {
      final originalBytes = await readAsBytes();

      // Browser captures are already encoded image blobs. Native compression
      // plugins are not consistently available on Web, so upload the bytes
      // directly instead of failing after the photo is accepted.
      if (kIsWeb) {
        return MultipartFile.fromBytes(
          fieldName,
          originalBytes,
          filename: fileName,
        );
      }

      final compressed = await FlutterImageCompress.compressWithList(
        originalBytes,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
        format: _detectFormat(),
        keepExif: true,
      );
      if (compressed.isEmpty) {
        throw Exception('Image compression failed');
      }

      return MultipartFile.fromBytes(fieldName, compressed, filename: fileName);
    }

    if (kIsWeb) {
      return MultipartFile.fromBytes(
        fieldName,
        await readAsBytes(),
        filename: fileName,
      );
    }

    // no compression on native
    return MultipartFile.fromPath(fieldName, path, filename: fileName);
  }

  Future<MultipartFile> toMultipart({
    String? filename,
    String fieldName = 'file',
  }) async {
    return MultipartFile.fromPath(fieldName, path, filename: filename ?? name);
  }

  bool _isImage(String fileName) {
    final lower = fileName.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp');
  }

  CompressFormat _detectFormat() {
    final lower = name.toLowerCase();
    if (lower.endsWith('.png')) return CompressFormat.png;
    if (lower.endsWith('.webp')) return CompressFormat.webp;
    return CompressFormat.jpeg;
  }
}
