import 'package:formz/formz.dart';

abstract class AppFormzInput<T, E> extends FormzInput<T, E> {
  const AppFormzInput.pure(super.value) : super.pure();
  const AppFormzInput.dirty(super.value) : super.dirty();

  bool get isValidValue => validator(value) == null;

  String? get errorMessage;
}
