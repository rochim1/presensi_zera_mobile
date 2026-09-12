import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

class GlobalImageParamsEntity extends Equatable {
  final String? mimeType;
  final String? name;
  final int? length;
  final String? path;

  /// is required type of file,
  /// convert String [path] to [MultipartFile]
  /// ```
  /// AppUtility.toMultipartFile(path);
  /// ```
  final MultipartFile? file;

  GlobalImageParamsEntity({
    this.mimeType,
    this.name,
    this.length,
    this.path,
    required this.file,
  });

  @override
  List<Object?> get props {
    return [file, mimeType, name, length, path];
  }

  @override
  bool get stringify => true;
}
