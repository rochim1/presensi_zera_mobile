import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class EmailListState extends Equatable {
  final int unreadCount;
  const EmailListState({this.unreadCount = 0});

  @override
  List<Object> get props => [unreadCount];
}

class EmailListInitial extends EmailListState {
  const EmailListInitial({super.unreadCount = 0});
}

class EmailListLoading extends EmailListState {
  const EmailListLoading({super.unreadCount});
}

class EmailListLoaded extends EmailListState {
  final List<EmailEntity> emails;

  const EmailListLoaded(this.emails, {super.unreadCount});

  @override
  List<Object> get props => [emails, unreadCount];
}

class EmailListError extends EmailListState {
  final String message;

  const EmailListError(this.message, {super.unreadCount});

  @override
  List<Object> get props => [message, unreadCount];
}
