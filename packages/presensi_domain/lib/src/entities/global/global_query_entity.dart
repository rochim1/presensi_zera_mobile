import 'package:equatable/equatable.dart';

class GlobalQueryEntity extends Equatable {
  final String query;
  final String boxKey;
  final int createAt;

  const GlobalQueryEntity({
    required this.query,
    required this.createAt,
    required this.boxKey,
  });

  @override
  List<Object> get props => [query, createAt, boxKey];

  @override
  bool get stringify => true;
}
