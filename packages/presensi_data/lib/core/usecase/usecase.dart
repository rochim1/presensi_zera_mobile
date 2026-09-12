import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';

/// [Type] it`s type [return] of function [call].
/// [Params] is [parameters] put the function in the [call]
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Class to handle when useCase don't need params
class NoParams extends Equatable {
  @override
  List<Object?> get props => [''];
}
