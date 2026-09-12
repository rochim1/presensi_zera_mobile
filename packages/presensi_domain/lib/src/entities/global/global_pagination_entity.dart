import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';

class GlobalPaginationEntity extends Equatable {
  final int? limit;
  final int? page;

  const GlobalPaginationEntity({this.limit = LIMIT, this.page = 0});

  @override
  List<Object?> get props => [limit, page];

  GlobalPaginationEntity copyWith({int? limit, int? page}) {
    return GlobalPaginationEntity(
      limit: limit ?? this.limit,
      page: page ?? this.page,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'limit': limit, 'page': page};
  }
}
