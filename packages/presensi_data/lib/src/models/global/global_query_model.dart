import 'package:hive_flutter/hive_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'global_query_model.g.dart';

@HiveType(typeId: 7)
class GlobalQueryModel extends GlobalQueryEntity {
  @HiveField(0)
  final String query;
  @HiveField(1)
  final int createAt;
  @HiveField(2)
  final String boxKey;

  const GlobalQueryModel({
    required this.query,
    required this.createAt,
    required this.boxKey,
  }) : super(query: query, createAt: createAt, boxKey: boxKey);

  GlobalQueryModel copyWith({
    int? id,
    String? query,
    int? createAt,
    String? boxKey,
  }) {
    return GlobalQueryModel(
      query: query ?? this.query,
      createAt: createAt ?? this.createAt,
      boxKey: boxKey ?? this.boxKey,
    );
  }

  @override
  String toString() =>
      'GlobalQueryModel(query: $query, createAt: $createAt, boxKey: $boxKey)';
}
