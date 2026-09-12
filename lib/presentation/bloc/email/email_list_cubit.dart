import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_data/core/_core.dart';
import 'email_list_state.dart';

import 'package:presensi_mobile/service/websocket_service.dart';

class EmailListCubit extends Cubit<EmailListState> {
  final GetAllEmailUsecase getAllEmailUsecase;
  final CountUnreadEmailUsecase getUnreadEmailCountUseCase;
  final ReadEmailUsecase readEmailUsecase;

  EmailListCubit({
    required this.getAllEmailUsecase,
    required this.getUnreadEmailCountUseCase,
    required this.readEmailUsecase,
  }) : super(const EmailListInitial()) {
    _init();
  }

  void _init() {
    WebSocketService.instance.addNotificationListener(_onWsNotification);
    fetchUnreadCount();
  }

  void _onWsNotification(Map<String, dynamic> data) {
    final type = data['type']?.toString() ?? '';
    if (type == 'email_received' || type == 'email_read') {
      fetchUnreadCount();
      fetchEmails();
    }
  }

  Future<void> fetchUnreadCount() async {
    final result = await getUnreadEmailCountUseCase(NoParams());
    result.fold(
      (failure) => null,
      (count) {
        if (state is EmailListLoaded) {
          emit(EmailListLoaded((state as EmailListLoaded).emails, unreadCount: count));
        } else if (state is EmailListLoading) {
          emit(EmailListLoading(unreadCount: count));
        } else if (state is EmailListError) {
          emit(EmailListError((state as EmailListError).message, unreadCount: count));
        } else {
          emit(EmailListInitial(unreadCount: count));
        }
      },
    );
  }

  Future<void> fetchEmails() async {
    emit(EmailListLoading(unreadCount: state.unreadCount));
    final failureOrEmails = await getAllEmailUsecase(const GetAllEmailParams(limit: 50, offset: 0));
    failureOrEmails.fold(
      (failure) => emit(EmailListError(failure.message ?? 'Terjadi kesalahan tidak terduga', unreadCount: state.unreadCount)),
      (emails) => emit(EmailListLoaded(emails, unreadCount: state.unreadCount)),
    );
  }

  Future<void> markAsRead(String emailId) async {
    if (state is EmailListLoaded) {
      final currentState = state as EmailListLoaded;
      final emailList = currentState.emails;
      final emailIndex = emailList.indexWhere((e) => e.id == emailId);
      
      if (emailIndex != -1 && emailList[emailIndex].isRead != true) {
        // Optimistic UI update
        final updatedEmails = List<EmailEntity>.from(emailList);
        final unreadCount = (state.unreadCount > 0) ? state.unreadCount - 1 : 0;
        
        // We don't have copyWith on EmailEntity, so we might not be able to easily update the isRead property if it's immutable
        // Usually, we'd do: updatedEmails[emailIndex] = updatedEmails[emailIndex].copyWith(isRead: true);
        // Let's just refetch after calling the API
      }
    }

    final result = await readEmailUsecase(emailId);
    result.fold(
      (l) => null,
      (r) {
        fetchUnreadCount();
        fetchEmails();
      }
    );
  }

  @override
  Future<void> close() {
    WebSocketService.instance.removeNotificationListener(_onWsNotification);
    return super.close();
  }
}
