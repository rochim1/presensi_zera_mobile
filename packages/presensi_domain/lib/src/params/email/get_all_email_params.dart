import 'package:equatable/equatable.dart';

class GetAllEmailParams extends Equatable {
  final Map<String, dynamic>? filter;
  final int? limit;
  final int? offset;

  const GetAllEmailParams({
    this.filter,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [filter, limit, offset];
}
