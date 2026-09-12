import 'package:equatable/equatable.dart';

class VanStockFilterParams extends Equatable {
  final String? salesmanId;
  final int page;
  final int limit;

  const VanStockFilterParams({
    this.salesmanId,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [salesmanId, page, limit];
}
