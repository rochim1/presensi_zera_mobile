import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'announcement_state.freezed.dart';

@freezed
abstract class AnnouncementState with _$AnnouncementState {
  const factory AnnouncementState({
    @Default(BasePaginatedState.initial())
    BasePaginatedState<Announcement> announcements,
  }) = _AnnouncementState;
}
