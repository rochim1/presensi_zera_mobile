part of 'global_map_cubit.dart';

class GlobalMapState extends Equatable {
  final TypeState typeState;
  final bool isLocationGranted;
  final String? message;
  final LatLng? targetPosition;
  final GlobalAddressEntity? address;

  const GlobalMapState({
    this.typeState = TypeState.initial,
    this.isLocationGranted = false,
    this.message,
    this.targetPosition,
    this.address,
  });

  @override
  List<Object?> get props => [
    typeState,
    targetPosition,
    isLocationGranted,
    message,
    address,
  ];

  GlobalMapState copyWith({
    TypeState? typeState,
    bool? isLocationGranted,
    String? message,
    LatLng? targetPosition,
    GlobalAddressEntity? address,
  }) {
    return GlobalMapState(
      typeState: typeState ?? this.typeState,
      targetPosition: targetPosition ?? this.targetPosition,
      isLocationGranted: isLocationGranted ?? this.isLocationGranted,
      message: message ?? this.message,
      address: address ?? this.address,
    );
  }
}
