import 'package:equatable/equatable.dart';

class UserImageParamsEntity extends Equatable {
  final String? mimeType;
  final String? name;
  final int? length;
  final String? path;

  UserImageParamsEntity({this.mimeType, this.name, this.length, this.path});

  @override
  List<Object?> get props {
    return [mimeType, name, length, path];
  }
}
