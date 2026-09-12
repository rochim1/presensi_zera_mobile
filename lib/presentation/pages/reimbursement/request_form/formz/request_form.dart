import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'inputs/_inputs.dart';

part 'request_form.freezed.dart';

@freezed
abstract class ReimbursementRequestFormInputs
    with _$ReimbursementRequestFormInputs, FormzMixin {
  const ReimbursementRequestFormInputs._();

  const factory ReimbursementRequestFormInputs({
    @Default(CategoryInput.pure()) CategoryInput category,
    @Default(TitleInput.pure()) TitleInput title,
    @Default(DescriptionInput.pure()) DescriptionInput description,
    @Default(ReimbursementDateInput.pure()) ReimbursementDateInput date,
    @Default(CurrencyInput.pure()) CurrencyInput currency,
    @Default(NominalInput.pure()) NominalInput nominal,
    @Default(ReimbursementAttachmentsInput.pure())
    ReimbursementAttachmentsInput attachments,
    @Default(NotesInput.pure()) NotesInput notes,
  }) = _ReimbursementRequestFormInputs;

  @override
  List<FormzInput> get inputs => [
    category,
    title,
    description,
    date,
    currency,
    nominal,
    attachments,
    notes,
  ];
}
