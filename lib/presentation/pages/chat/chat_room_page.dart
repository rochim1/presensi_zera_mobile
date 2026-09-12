import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/chat/chat_room_cubit.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:intl/intl.dart';

@RoutePage()
class ChatRoomPage extends StatefulWidget implements AutoRouteWrapper {
  final String conversationId;
  final String chatTitle;
  final String chatAvatar;
  final bool embedded;

  const ChatRoomPage({
    super.key,
    required this.conversationId,
    required this.chatTitle,
    required this.chatAvatar,
    this.embedded = false,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (context) => sl<ChatRoomCubit>(), child: this);
  }

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatRoomCubit>().fetchMessages(
      widget.conversationId,
      refresh: true,
    );

    // Connect WebSocket
    context.read<ChatRoomCubit>().initWebSocket(widget.conversationId);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final messagesState = context.read<ChatRoomCubit>().state.messages;
        if (!messagesState.isLoadingNext &&
            !messagesState.isLoading &&
            !messagesState.isError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.read<ChatRoomCubit>().fetchMessages(
                widget.conversationId,
              );
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final currentUserId = context.read<AppCubit>().state.user.data?.id;
    context.read<ChatRoomCubit>().sendMessage(
      widget.conversationId,
      text,
      type: 'text',
      currentUserId: currentUserId,
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AppCubit>().state.user.data?.id;
    final firstLetter = widget.chatTitle.isNotEmpty
        ? widget.chatTitle[0].toUpperCase()
        : '?';

    return Scaffold(
      appBar: widget.embedded
          ? null
          : AppTopBar(
              title: widget.chatTitle,
              backgroundColor: AppColors.transparent,
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.embedded) ...[
                    AppTopBarActionButton(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: AppDimens.w8),
                  ],
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.white.withValues(alpha: 0.2),
                    backgroundImage: widget.chatAvatar.isNotEmpty
                        ? NetworkImage(widget.chatAvatar)
                        : null,
                    child: widget.chatAvatar.isEmpty
                        ? Text(
                            firstLetter,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
      body: Column(
        children: [
          if (widget.embedded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(bottom: BorderSide(color: AppColors.divider)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primaryLight,
                    backgroundImage: widget.chatAvatar.isNotEmpty
                        ? NetworkImage(widget.chatAvatar)
                        : null,
                    child: widget.chatAvatar.isEmpty
                        ? Text(
                            firstLetter,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.chatTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyle.titleMedium?.copyWith(
                        color: AppColors.labelPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: BlocBuilder<ChatRoomCubit, ChatRoomState>(
              builder: (context, state) {
                final messages = state.messages;

                if (messages.isLoading && messages.data.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2.5,
                    ),
                  );
                }

                if (messages.isSuccess && messages.data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          PhosphorIcons.chatCircleFill,
                          size: 56,
                          color: AppColors.labelSecondary.withValues(
                            alpha: 0.25,
                          ),
                        ),
                        AppDimens.h12.hSpace,
                        Text(
                          'Belum ada pesan',
                          style: context.textStyle.titleSmall?.copyWith(
                            color: AppColors.labelSecondary,
                          ),
                        ),
                        AppDimens.h4.hSpace,
                        Text(
                          'Kirim pesan pertama Anda!',
                          style: context.textStyle.bodySmall?.copyWith(
                            color: AppColors.labelSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.w16,
                    vertical: AppDimens.h8,
                  ),
                  itemCount:
                      messages.data.length + (messages.hasReachedMax ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index >= messages.data.length) {
                      return Padding(
                        padding: EdgeInsets.all(AppDimens.h16),
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    }

                    final message = messages.data[index];
                    final isMe = message.senderId == currentUserId;

                    // Date separator logic
                    Widget? dateSeparator;
                    if (index < messages.data.length - 1) {
                      final curr = _parseDate(message.createdAt);
                      final next = _parseDate(
                        messages.data[index + 1].createdAt,
                      );
                      if (curr != null &&
                          next != null &&
                          (curr.day != next.day ||
                              curr.month != next.month ||
                              curr.year != next.year)) {
                        dateSeparator = _buildDateSeparator(curr);
                      }
                    } else if (index == messages.data.length - 1) {
                      final curr = _parseDate(message.createdAt);
                      if (curr != null) {
                        dateSeparator = _buildDateSeparator(curr);
                      }
                    }

                    return Column(
                      children: [
                        ?dateSeparator,
                        _buildMessageBubble(context, message, isMe),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null) return null;
    final timestamp = int.tryParse(dateStr);
    if (timestamp != null) {
      // Assuming timestamp is in milliseconds. If it's seconds, multiply by 1000.
      // Usually JS/Dart timestamps are milliseconds if 13 digits.
      return DateTime.fromMillisecondsSinceEpoch(
        dateStr.length == 10 ? timestamp * 1000 : timestamp,
      ).toLocal();
    }
    try {
      return DateTime.parse(dateStr).toLocal();
    } catch (_) {
      return null;
    }
  }

  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    String label;
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      label = 'Hari Ini';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      label = 'Kemarin';
    } else {
      label = DateFormat('dd MMMM yyyy', 'id').format(date);
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.h12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.labelSecondary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppDimens.r100),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.labelSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    MessageEntity message,
    bool isMe,
  ) {
    final messageDate = _parseDate(message.createdAt);
    final timeStr = messageDate == null
        ? ''
        : DateFormat('HH:mm').format(messageDate.toLocal());

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          _showThreadBottomSheet(context, message);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 6, top: 2),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isMe ? AppColors.primaryDark : AppColors.white,
            border: isMe ? null : Border.all(color: AppColors.border),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 12 : 0),
              topRight: Radius.circular(isMe ? 0 : 12),
              bottomLeft: const Radius.circular(12),
              bottomRight: const Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe && message.sender?.name != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    message.sender!.name!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Text(
                      message.content ?? '',
                      style: TextStyle(
                        color: isMe ? Colors.white : AppColors.labelPrimary,
                        fontSize: 15.5,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 11,
                            color: isMe
                                ? Colors.white.withValues(alpha: 0.75)
                                : AppColors.labelSecondary,
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          Icon(
                            PhosphorIcons.checks,
                            size: 14,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (message.threadCount != null && message.threadCount! > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: InkWell(
                    onTap: () {
                      _showThreadBottomSheet(context, message);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          PhosphorIcons.chatsCircle,
                          size: 16,
                          color: isMe
                              ? Colors.white.withValues(alpha: 0.9)
                              : AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${message.threadCount} balasan',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isMe ? Colors.white : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThreadBottomSheet(
    BuildContext context,
    MessageEntity parentMessage,
  ) {
    context.read<ChatRoomCubit>().setActiveThread(parentMessage);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<ChatRoomCubit>(),
          child: DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (_, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.bgPrimary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Thread Balasan',
                            style: context.textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(bottomSheetContext),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: BlocBuilder<ChatRoomCubit, ChatRoomState>(
                        builder: (context, state) {
                          final threadMessages = state.threadMessages;

                          return Column(
                            children: [
                              // Parent Message
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: _buildMessageBubble(
                                  context,
                                  parentMessage,
                                  parentMessage.senderId ==
                                      context
                                          .read<AppCubit>()
                                          .state
                                          .user
                                          .data
                                          ?.id,
                                ),
                              ),
                              const Divider(height: 1),
                              // Thread Messages
                              Expanded(
                                child:
                                    threadMessages.isLoading &&
                                        threadMessages.data.isEmpty
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ListView.builder(
                                        controller: scrollController,
                                        reverse: true,
                                        padding: const EdgeInsets.all(16),
                                        itemCount: threadMessages.data.length,
                                        itemBuilder: (context, index) {
                                          final msg =
                                              threadMessages.data[index];
                                          final isMe =
                                              msg.senderId ==
                                              context
                                                  .read<AppCubit>()
                                                  .state
                                                  .user
                                                  .data
                                                  ?.id;
                                          return _buildMessageBubble(
                                            context,
                                            msg,
                                            isMe,
                                          );
                                        },
                                      ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(
                          bottomSheetContext,
                        ).viewInsets.bottom,
                      ),
                      child: _buildThreadInput(context, parentMessage.id!),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      if (!context.mounted) return;
      context.read<ChatRoomCubit>().setActiveThread(null);
    });
  }

  Widget _buildThreadInput(BuildContext context, String parentId) {
    final threadController = TextEditingController();
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: threadController,
              decoration: InputDecoration(
                hintText: 'Balas di thread...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFF5F7F9),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              if (threadController.text.trim().isNotEmpty) {
                final currentUserId = context
                    .read<AppCubit>()
                    .state
                    .user
                    .data
                    ?.id;
                context.read<ChatRoomCubit>().sendMessage(
                  widget.conversationId,
                  threadController.text.trim(),
                  type: 'text',
                  parentMessageId: parentId,
                  currentUserId: currentUserId,
                );
                threadController.clear();
              }
            },
            icon: Icon(PhosphorIcons.paperPlaneRightFill),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.w12,
        vertical: AppDimens.h8,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InkWell(
                onTap: () {
                  // TODO: Handle attachment
                },
                borderRadius: BorderRadius.circular(AppDimens.r100),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    PhosphorIcons.paperclip,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppDimens.w8),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Ketik pesan...',
                    hintStyle: TextStyle(
                      color: AppColors.labelSecondary,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: true,
                    fillColor: Colors.transparent,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: TextStyle(fontSize: 14, color: AppColors.labelPrimary),
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                ),
              ),
            ),
            SizedBox(width: AppDimens.w8),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InkWell(
                onTap: _sendMessage,
                borderRadius: BorderRadius.circular(AppDimens.r100),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.labelPrimary.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    PhosphorIcons.paperPlaneTiltFill,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
