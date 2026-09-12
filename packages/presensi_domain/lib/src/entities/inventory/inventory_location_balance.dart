import 'package:equatable/equatable.dart';

class InventoryLocationBalance extends Equatable {
  final String id;
  final String? branchId;
  final String? branchName;
  final String? buildingName;
  final String? roomName;
  final String? rackName;
  final double quantity;

  const InventoryLocationBalance({
    required this.id,
    this.branchId,
    this.branchName,
    this.buildingName,
    this.roomName,
    this.rackName,
    this.quantity = 0,
  });

  String get label => [
    branchName,
    buildingName,
    roomName,
    rackName,
  ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' • ');

  @override
  List<Object?> get props => [
    id,
    branchId,
    branchName,
    buildingName,
    roomName,
    rackName,
    quantity,
  ];
}
