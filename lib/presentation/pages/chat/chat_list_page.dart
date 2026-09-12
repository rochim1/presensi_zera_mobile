import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/chat/chat_list_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/email/email_list_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/email/email_list_state.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

import 'chat_room_page.dart';
import 'email_detail_page.dart';

@RoutePage()
class ChatListPage extends StatefulWidget implements AutoRouteWrapper {
  const ChatListPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ChatListCubit>()),
        BlocProvider(create: (context) => sl<EmailListCubit>()),
      ],
      child: this,
    );
  }

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  final List<String> _tabTypes = ['private', 'group', 'email'];
  ConversationEntity? _selectedConversation;
  EmailEntity? _selectedEmail;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
    context.read<ChatListCubit>().fetchConversations(
      refresh: true,
      type: _tabTypes[0],
    );
    context.read<EmailListCubit>().fetchEmails();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _tabController.index >= 2) return;
    if (_scrollController.position.extentAfter < 240) {
      context.read<ChatListCubit>().fetchConversations(
        type: _tabTypes[_tabController.index],
      );
    }
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      if (_tabController.index < 2) {
        context.read<ChatListCubit>().fetchConversations(
          refresh: true,
          type: _tabTypes[_tabController.index],
        );
      }
      setState(() {
        _selectedConversation = null;
        _selectedEmail = null;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  ChatParticipantEntity? _getChatCounterpart(ConversationEntity conv) {
    final participants = conv.participants ?? const <ChatParticipantEntity>[];
    if (participants.isEmpty) return null;
    final currentUserId = context.read<AppCubit>().state.user.data?.id;
    if (currentUserId == null || currentUserId.isEmpty) {
      return participants.first;
    }
    return participants.firstWhere(
      (participant) => participant.id != currentUserId,
      orElse: () => participants.first,
    );
  }

  String _getChatAvatar(ConversationEntity conv) {
    if (conv.type == 'group' && conv.groupAvatar != null) {
      return conv.groupAvatar!;
    }
    return _getChatCounterpart(conv)?.urlFoto ?? '';
  }

  String _getChatTitle(ConversationEntity conv) {
    if (conv.type == 'group') return conv.groupName ?? 'Group Chat';
    final counterpart = _getChatCounterpart(conv);
    return counterpart?.name ?? counterpart?.username ?? 'Chat';
  }

  EmailUserEntity? _getEmailCounterpart(EmailEntity email) {
    final currentUserId = context.read<AppCubit>().state.user.data?.id;
    if (currentUserId != null && email.senderId?.id == currentUserId) {
      return email.userId;
    }
    return email.senderId ?? email.userId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.geometricBg),
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
            ),
          ),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Cari pesan...',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pesan Internal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Komunikasi aman dalam perusahaan',
                    style: TextStyle(
                      color: Color(0xCCFFFFFF),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
        actions: [
          if (!_isSearching) ...[
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: [
            const Tab(text: 'CHAT'),
            const Tab(text: 'GRUP'),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('EMAIL'),
                  BlocBuilder<EmailListCubit, EmailListState>(
                    builder: (context, state) {
                      if (state.unreadCount > 0) {
                        return Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.danger,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${state.unreadCount}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.push(const ChatSearchUserPageRoute());
        },
        backgroundColor: AppColors.primary,
        elevation: 3,
        child: const Icon(PhosphorIcons.chatCircleDots, color: Colors.white),
      ),
      floatingActionButtonLocation: MediaQuery.sizeOf(context).width >= 840
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final list = _buildActiveList();
          if (constraints.maxWidth < 840) return list;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: constraints.maxWidth >= 1200 ? 420 : 360,
                child: list,
              ),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(child: _buildDesktopDetail()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActiveList() {
    return _tabController.index == 2
        ? _buildEmailList()
        : BlocBuilder<ChatListCubit, ChatListState>(
            builder: (context, state) {
              final conversations = state.conversations;

              if (conversations.isLoading && conversations.data.isEmpty) {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: AppDimens.h8),
                  itemCount: 8,
                  itemBuilder: (_, _) => _buildShimmerCard(),
                );
              }

              if (conversations.isError) {
                return AppErrorView(
                  failure: conversations.failure!,
                  onRetry: () {
                    context.read<ChatListCubit>().fetchConversations(
                      refresh: true,
                      type: _tabTypes[_tabController.index],
                    );
                  },
                );
              }

              if (conversations.isSuccess &&
                  conversations.data.isEmpty &&
                  _searchQuery.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PhosphorIcons.chatCircleDotsFill,
                        size: 64,
                        color: AppColors.labelSecondary.withValues(alpha: 0.3),
                      ),
                      AppDimens.h16.hSpace,
                      Text(
                        'Belum ada percakapan',
                        style: context.textStyle.titleMedium?.copyWith(
                          color: AppColors.labelSecondary,
                        ),
                      ),
                      AppDimens.h8.hSpace,
                      Text(
                        'Mulai percakapan baru dengan\nmenekan tombol pesan di bawah',
                        textAlign: TextAlign.center,
                        style: context.textStyle.bodySmall?.copyWith(
                          color: AppColors.labelSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final displayedConversations = _searchQuery.isEmpty
                  ? conversations.data
                  : conversations.data
                        .where(
                          (conv) => _getChatTitle(
                            conv,
                          ).toLowerCase().contains(_searchQuery.toLowerCase()),
                        )
                        .toList();

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ChatListCubit>().fetchConversations(
                    refresh: true,
                    type: _tabTypes[_tabController.index],
                  );
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: displayedConversations.length,
                  itemBuilder: (context, index) {
                    final conv = displayedConversations[index];
                    return _buildConversationListTile(context, conv);
                  },
                ),
              );
            },
          );
  }

  Widget _buildDesktopDetail() {
    final email = _selectedEmail;
    if (email != null) {
      return EmailDetailPage(
        key: ValueKey('email-${email.id}'),
        email: email,
        embedded: true,
      );
    }

    final conversation = _selectedConversation;
    if (conversation != null) {
      return ChatRoomPage(
        key: ValueKey('chat-${conversation.id}'),
        conversationId: conversation.id ?? '',
        chatTitle: _getChatTitle(conversation),
        chatAvatar: _getChatAvatar(conversation),
        embedded: true,
      ).wrappedRoute(context);
    }

    return ColoredBox(
      color: AppColors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _tabController.index == 2
                  ? PhosphorIcons.envelopeSimple
                  : PhosphorIcons.chatCircleDots,
              size: 64,
              color: AppColors.primary.withValues(alpha: 0.25),
            ),
            const SizedBox(height: 16),
            Text(
              _tabController.index == 2
                  ? 'Pilih email untuk melihat detail'
                  : 'Pilih percakapan untuk mulai melihat pesan',
              style: context.textStyle.titleMedium?.copyWith(
                color: AppColors.labelSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationListTile(
    BuildContext context,
    ConversationEntity conv,
  ) {
    final avatar = _getChatAvatar(conv);
    final title = _getChatTitle(conv);
    final lastMsg = conv.lastMessage?.content ?? 'Mulai percakapan';
    final unread = conv.unreadCount ?? 0;
    final isSelected = _selectedConversation?.id == conv.id;

    // Format time for last message
    String timeLabel = '';
    if (conv.lastMessage?.sentAt != null) {
      try {
        final dt = DateTime.parse(conv.lastMessage!.sentAt!).toLocal();
        final now = DateTime.now();
        if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
          timeLabel = DateFormat('HH:mm').format(dt);
        } else {
          timeLabel = DateFormat('dd/MM').format(dt);
        }
      } catch (_) {}
    }

    return Material(
      color: isSelected
          ? AppColors.primary.withValues(alpha: 0.09)
          : AppColors.white,
      child: InkWell(
        onTap: () async {
          if (MediaQuery.sizeOf(context).width >= 840) {
            setState(() {
              _selectedConversation = conv;
              _selectedEmail = null;
            });
            return;
          }
          await context.router.push(
            ChatRoomPageRoute(
              conversationId: conv.id ?? '',
              chatTitle: title,
              chatAvatar: avatar,
            ),
          );
          if (context.mounted) {
            context.read<ChatListCubit>().fetchConversations(
              refresh: true,
              type: _tabTypes[_tabController.index],
            );
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.w16,
            vertical: AppDimens.h14,
          ),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 4,
              ),
              bottom: const BorderSide(color: AppColors.divider, width: 1),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: avatar.isNotEmpty
                    ? NetworkImage(avatar)
                    : null,
                child: avatar.isEmpty
                    ? Icon(
                        conv.type == 'group' ? Icons.group : Icons.person,
                        color: AppColors.primary,
                        size: 28,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                conv.type == 'group'
                                    ? PhosphorIcons.usersFill
                                    : PhosphorIcons.userFill,
                                size: 16,
                                color: AppColors.labelTertiary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textStyle.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.labelPrimary,
                                        fontSize: 16,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (timeLabel.isNotEmpty)
                          Text(
                            timeLabel,
                            style: context.textStyle.bodySmall?.copyWith(
                              color: unread > 0
                                  ? AppColors.primary
                                  : AppColors.labelSecondary,
                              fontWeight: unread > 0
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMsg,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textStyle.bodyMedium?.copyWith(
                              color: AppColors.labelSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (unread > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unread > 99 ? '99+' : unread.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailList() {
    return BlocBuilder<EmailListCubit, EmailListState>(
      builder: (context, state) {
        if (state is EmailListLoading) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: AppDimens.h8),
            itemCount: 8,
            itemBuilder: (_, _) => _buildShimmerCard(),
          );
        }

        if (state is EmailListError) {
          return Center(child: Text(state.message));
        }

        if (state is EmailListLoaded) {
          final emails = state.emails;
          if (emails.isEmpty) {
            return const Center(child: Text('Belum ada email'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<EmailListCubit>().fetchEmails();
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: emails.length,
              itemBuilder: (context, index) {
                final email = emails[index];
                final counterpart = _getEmailCounterpart(email);
                final sender =
                    counterpart?.name ??
                    counterpart?.email ??
                    email.instansiId?.namaInstansi ??
                    'Sistem';
                final subject = email.title ?? 'No Subject';
                final snippet =
                    email.body?.replaceAll(RegExp(r'<[^>]*>'), '') ?? '';
                DateTime? parsedDate;
                if (email.createdAt != null) {
                  final timestamp = int.tryParse(email.createdAt!);
                  if (timestamp != null) {
                    parsedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
                  } else {
                    parsedDate = DateTime.tryParse(email.createdAt!);
                  }
                }
                final time = parsedDate != null
                    ? DateFormat('dd/MM HH:mm').format(parsedDate.toLocal())
                    : '';

                final isRead = email.isRead ?? true;
                final isSelected = _selectedEmail?.id == email.id;
                final senderAvatar = counterpart?.urlFoto ?? '';

                return InkWell(
                  onTap: () {
                    if (!isRead && email.id != null) {
                      context.read<EmailListCubit>().markAsRead(email.id!);
                    }
                    if (MediaQuery.sizeOf(context).width >= 840) {
                      setState(() {
                        _selectedEmail = email;
                        _selectedConversation = null;
                      });
                      return;
                    }
                    context.router.push(EmailDetailPageRoute(email: email));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.09)
                          : AppColors.white,
                      border: Border(
                        left: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 4,
                        ),
                        bottom: const BorderSide(
                          color: AppColors.divider,
                          width: 1,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.w16,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          backgroundImage: senderAvatar.isNotEmpty
                              ? NetworkImage(senderAvatar)
                              : null,
                          child: senderAvatar.isEmpty
                              ? Text(
                                  sender.isNotEmpty
                                      ? sender[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      sender,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textStyle.titleMedium
                                          ?.copyWith(
                                            fontWeight: isRead
                                                ? FontWeight.w600
                                                : FontWeight.bold,
                                            color: AppColors.labelPrimary,
                                            fontSize: 15,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    time,
                                    style: context.textStyle.bodySmall
                                        ?.copyWith(
                                          color: isRead
                                              ? AppColors.labelSecondary
                                              : AppColors.primary,
                                          fontWeight: isRead
                                              ? FontWeight.normal
                                              : FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      subject,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textStyle.bodyMedium
                                          ?.copyWith(
                                            fontWeight: isRead
                                                ? FontWeight.w500
                                                : FontWeight.bold,
                                            color: AppColors.labelPrimary,
                                          ),
                                    ),
                                  ),
                                  if (!isRead)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                snippet,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textStyle.bodySmall?.copyWith(
                                  color: AppColors.labelSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.w16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppShimmer.circle(size: 52),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppShimmer.box(width: 200, height: 16),
                const SizedBox(height: 8),
                AppShimmer.box(width: 140, height: 14),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppShimmer.box(width: 40, height: 12),
              const SizedBox(height: 8),
              AppShimmer.circle(size: 20),
            ],
          ),
        ],
      ),
    );
  }
}
