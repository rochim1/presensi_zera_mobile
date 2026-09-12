import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_data/core/failure/failure.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:presensi_mobile/service/websocket_service.dart';

part 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final ChatGetMessagesUseCase getMessagesUseCase;
  final ChatGetThreadMessagesUseCase getThreadMessagesUseCase;
  final ChatSendMessageUseCase sendMessageUseCase;
  final ChatMarkMessagesAsReadUseCase markMessagesAsReadUseCase;
  final ChatConnectWebSocketUseCase connectWebSocketUseCase;
  final ChatDisconnectWebSocketUseCase disconnectWebSocketUseCase;

  ChatRoomCubit({
    required this.getMessagesUseCase,
    required this.getThreadMessagesUseCase,
    required this.sendMessageUseCase,
    required this.markMessagesAsReadUseCase,
    required this.connectWebSocketUseCase,
    required this.disconnectWebSocketUseCase,
  }) : super(const ChatRoomState());

  static const int _limit = 50;

  Future<void> fetchMessages(
    String conversationId, {
    bool refresh = false,
  }) async {
    if (refresh) {
      emit(const ChatRoomState(messages: BasePaginatedState.loading()));
    } else {
      if (state.messages.isLoading ||
          state.messages.isLoadingNext ||
          state.messages.hasReachedMax)
        return;
      emit(
        state.copyWith(
          messages: BasePaginatedState.loadingNext(
            data: state.messages.data,
            page: state.messages.currentPage,
            hasReachedMax: state.messages.hasReachedMax,
          ),
        ),
      );
    }

    final currentPage = refresh ? 1 : state.messages.currentPage;

    try {
      final result = await getMessagesUseCase(
        conversationId,
        page: currentPage,
        limit: _limit,
      );

      result.fold(
        (failure) {
          emit(state.copyWith(messages: BasePaginatedState.failure(failure)));
        },
        (data) {
          final sortedData = List<MessageEntity>.from(data)
            ..sort((a, b) {
              DateTime? parseDate(String? d) {
                if (d == null) return null;
                final ts = int.tryParse(d);
                if (ts != null)
                  return DateTime.fromMillisecondsSinceEpoch(
                    d.length == 10 ? ts * 1000 : ts,
                  );
                return DateTime.tryParse(d);
              }

              final dateA = parseDate(a.createdAt);
              final dateB = parseDate(b.createdAt);
              if (dateA == null || dateB == null) return 0;
              return dateB.compareTo(dateA); // Descending (newest first)
            });

          final allData = refresh
              ? sortedData
              : [...state.messages.data, ...sortedData];
          emit(
            state.copyWith(
              messages: BasePaginatedState.success(
                data: allData,
                page: currentPage + 1,
                hasReachedMax: data.length < _limit,
              ),
            ),
          );

          // Mark as read after fetching
          markMessagesAsReadUseCase(conversationId);
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          messages: BasePaginatedState.failure(
            ServerFailure(message: e.toString()),
          ),
        ),
      );
    }
  }

  Future<void> sendMessage(
    String conversationId,
    String content, {
    String? type,
    String? parentMessageId,
    String? currentUserId,
  }) async {
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempMsg = MessageEntity(
      id: tempId,
      conversationId: conversationId,
      senderId: currentUserId,
      content: content,
      type: type,
      parentMessageId: parentMessageId,
      status: 'sending',
      createdAt: DateTime.now().toUtc().toIso8601String(),
    );

    // Optimistic Update
    if (parentMessageId != null) {
      emit(
        state.copyWith(
          threadMessages: BasePaginatedState.success(
            data: [tempMsg, ...state.threadMessages.data],
            page: state.threadMessages.currentPage,
            hasReachedMax: state.threadMessages.hasReachedMax,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          messages: BasePaginatedState.success(
            data: [tempMsg, ...state.messages.data],
            page: state.messages.currentPage,
            hasReachedMax: state.messages.hasReachedMax,
          ),
        ),
      );
    }

    final result = await sendMessageUseCase(
      conversationId: conversationId,
      content: content,
      type: type,
      parentMessageId: parentMessageId,
    );

    result.fold(
      (failure) {
        SmartDialog.showToast(failure.message);
        // Revert on failure
        if (parentMessageId != null) {
          emit(
            state.copyWith(
              threadMessages: BasePaginatedState.success(
                data: state.threadMessages.data
                    .where((m) => m.id != tempId)
                    .toList(),
                page: state.threadMessages.currentPage,
                hasReachedMax: state.threadMessages.hasReachedMax,
              ),
            ),
          );
        } else {
          emit(
            state.copyWith(
              messages: BasePaginatedState.success(
                data: state.messages.data.where((m) => m.id != tempId).toList(),
                page: state.messages.currentPage,
                hasReachedMax: state.messages.hasReachedMax,
              ),
            ),
          );
        }
      },
      (message) {
        // Replace temp with real
        if (parentMessageId != null) {
          final newThreadMessages = state.threadMessages.data
              .map((m) => m.id == tempId ? message : m)
              .toList();
          emit(
            state.copyWith(
              threadMessages: BasePaginatedState.success(
                data: newThreadMessages,
                page: state.threadMessages.currentPage,
                hasReachedMax: state.threadMessages.hasReachedMax,
              ),
            ),
          );
        } else {
          final newMessages = state.messages.data
              .map((m) => m.id == tempId ? message : m)
              .toList();
          emit(
            state.copyWith(
              messages: BasePaginatedState.success(
                data: newMessages,
                page: state.messages.currentPage,
                hasReachedMax: state.messages.hasReachedMax,
              ),
            ),
          );
        }
      },
    );
  }

  void setActiveThread(MessageEntity? message) {
    emit(
      state.copyWith(
        activeThread: message,
        threadMessages: const BasePaginatedState.initial(),
      ),
    );
    if (message != null) {
      fetchThreadMessages(message.id!);
    }
  }

  Future<void> fetchThreadMessages(
    String parentMessageId, {
    bool refresh = false,
  }) async {
    if (refresh) {
      emit(state.copyWith(threadMessages: const BasePaginatedState.loading()));
    } else {
      if (state.threadMessages.isLoading ||
          state.threadMessages.isLoadingNext ||
          state.threadMessages.hasReachedMax)
        return;
      emit(
        state.copyWith(
          threadMessages: BasePaginatedState.loadingNext(
            data: state.threadMessages.data,
            page: state.threadMessages.currentPage,
            hasReachedMax: state.threadMessages.hasReachedMax,
          ),
        ),
      );
    }

    final currentPage = refresh ? 1 : state.threadMessages.currentPage;

    try {
      final result = await getThreadMessagesUseCase(
        parentMessageId,
        page: currentPage,
        limit: _limit,
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(threadMessages: BasePaginatedState.failure(failure)),
          );
        },
        (data) {
          final sortedData = List<MessageEntity>.from(data)
            ..sort((a, b) {
              DateTime? parseDate(String? d) {
                if (d == null) return null;
                final ts = int.tryParse(d);
                if (ts != null)
                  return DateTime.fromMillisecondsSinceEpoch(
                    d.length == 10 ? ts * 1000 : ts,
                  );
                return DateTime.tryParse(d);
              }

              final dateA = parseDate(a.createdAt);
              final dateB = parseDate(b.createdAt);
              if (dateA == null || dateB == null) return 0;
              return dateB.compareTo(dateA); // Descending (newest first)
            });

          final allData = refresh
              ? sortedData
              : [...state.threadMessages.data, ...sortedData];
          emit(
            state.copyWith(
              threadMessages: BasePaginatedState.success(
                data: allData,
                page: currentPage + 1,
                hasReachedMax: data.length < _limit,
              ),
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          threadMessages: BasePaginatedState.failure(
            ServerFailure(message: e.toString()),
          ),
        ),
      );
    }
  }

  String? _currentConversationId;

  void _onWsNotification(Map<String, dynamic> data) {
    final type = data['type']?.toString() ?? '';
    final conversationId = data['conversation_id']?.toString() ?? '';

    // Only refresh if this is a chat_message for the current conversation
    if (type == 'chat_message' && _currentConversationId != null) {
      if (conversationId == _currentConversationId) {
        fetchMessages(_currentConversationId!, refresh: true);
      }
    }
  }

  void initWebSocket(String conversationId) {
    _currentConversationId = conversationId;
    WebSocketService.instance.addNotificationListener(_onWsNotification);
  }

  @override
  Future<void> close() {
    WebSocketService.instance.removeNotificationListener(_onWsNotification);
    return super.close();
  }
}
