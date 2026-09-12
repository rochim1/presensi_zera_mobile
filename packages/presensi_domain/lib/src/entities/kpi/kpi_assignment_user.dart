import 'package:equatable/equatable.dart';

class KpiAssignmentUser extends Equatable {
  final String? id;
  final String? name;
  final String? username;
  final String? fotoUrl;
  final String? divisiName;
  final String? jabatanName;

  const KpiAssignmentUser({
    this.id,
    this.name,
    this.username,
    this.fotoUrl,
    this.divisiName,
    this.jabatanName,
  });

  @override
  List<Object?> get props => [id, name, username, fotoUrl, divisiName, jabatanName];
}
