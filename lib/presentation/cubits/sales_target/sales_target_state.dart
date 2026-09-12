part of 'sales_target_cubit.dart';

abstract class SalesTargetState extends Equatable {
  const SalesTargetState();

  @override
  List<Object?> get props => [];
}

class SalesTargetInitial extends SalesTargetState {}

class SalesTargetLoading extends SalesTargetState {}

class SalesTargetLoaded extends SalesTargetState {
  final SalesTargetEntity target;
  final String periode;

  const SalesTargetLoaded(this.target, this.periode);

  @override
  List<Object?> get props => [target, periode];
}

class SalesTargetEmpty extends SalesTargetState {
  final String periode;

  const SalesTargetEmpty(this.periode);

  @override
  List<Object?> get props => [periode];
}

class SalesTargetError extends SalesTargetState {
  final String message;

  const SalesTargetError(this.message);

  @override
  List<Object?> get props => [message];
}
