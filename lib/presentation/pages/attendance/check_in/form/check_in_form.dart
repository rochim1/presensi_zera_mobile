import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../formz/_formz.dart';

part 'check_in_form.freezed.dart';

@freezed
abstract class CheckInForm with _$CheckInForm, FormzMixin {
  const CheckInForm._();

  const factory CheckInForm({
    @Default(NoteInput.pure()) NoteInput keterangan,
    @Default(SelfieInput.pure()) SelfieInput photo,
    @Default(AttachmentInput.pure()) AttachmentInput attachment,
    @Default(LocationInput.pure()) LocationInput location,
  }) = _CheckInForm;

  @override
  List<FormzInput> get inputs => [keterangan, photo, attachment, location];
}
