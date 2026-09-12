import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../formz/_formz.dart';

part 'check_out_form.freezed.dart';

@freezed
abstract class CheckOutForm with _$CheckOutForm, FormzMixin {
  const CheckOutForm._();

  const factory CheckOutForm({
    @Default(NoteInput.pure()) NoteInput keterangan,
    @Default(SelfieInput.pure()) SelfieInput photo,
    @Default(AttachmentInput.pure()) AttachmentInput attachment,
    @Default(LocationInput.pure()) LocationInput location,
  }) = _CheckOutForm;

  @override
  List<FormzInput> get inputs => [keterangan, photo, attachment, location];
}
