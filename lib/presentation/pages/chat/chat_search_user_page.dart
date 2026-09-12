import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/bloc/chat/chat_search_user_cubit.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';
import 'dart:async';

@RoutePage()
class ChatSearchUserPage extends StatefulWidget implements AutoRouteWrapper {
  const ChatSearchUserPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatSearchUserCubit>(),
      child: this,
    );
  }

  @override
  State<ChatSearchUserPage> createState() => _ChatSearchUserPageState();
}

class _ChatSearchUserPageState extends State<ChatSearchUserPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ChatSearchUserCubit>().searchUsers('');
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<ChatSearchUserCubit>().searchUsers(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'Cari Pengguna',
        backgroundColor: AppColors.transparent,
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.w16,
              vertical: AppDimens.h12,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimens.r16),
                border: Border.all(color: AppColors.dividerLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Ketik nama pengguna...',
                  hintStyle: TextStyle(
                    color: AppColors.labelSecondary,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    PhosphorIcons.magnifyingGlass,
                    color: AppColors.labelSecondary,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDimens.w16,
                    vertical: AppDimens.h14,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.labelPrimary,
                ),
              ),
            ),
          ),

          // Buat Grup Baru Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.w16, vertical: AppDimens.h8),
            child: InkWell(
              onTap: () {
                context.router.push(const ChatCreateGroupPageRoute());
              },
              borderRadius: BorderRadius.circular(AppDimens.r12),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.w16, vertical: AppDimens.h12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderGrey),
                  borderRadius: BorderRadius.circular(AppDimens.r12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: AppDimens.r20,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(PhosphorIcons.usersThree, color: AppColors.primary, size: 20),
                    ),
                    SizedBox(width: AppDimens.w12),
                    Expanded(
                      child: Text(
                        'Buat Grup Baru',
                        style: context.textStyle.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Icon(PhosphorIcons.caretRight, color: AppColors.labelSecondary, size: 20),
                  ],
                ),
              ),
            ),
          ),
          
          // Results
          Expanded(
            child: BlocBuilder<ChatSearchUserCubit, ChatSearchUserState>(
              builder: (context, state) {
                final users = state.users;

                if (users.isLoading) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.w16,
                      vertical: AppDimens.h8,
                    ),
                    itemCount: 5,
                    separatorBuilder: (_, __) => AppDimens.h12.hSpace,
                    itemBuilder: (_, __) => _buildShimmerCard(),
                  );
                }

                if (users.isError) {
                  return AppErrorView(
                    failure: users.failure!,
                    onRetry: () {
                      final q = _searchController.text.trim();
                      if (q.isNotEmpty) {
                        context.read<ChatSearchUserCubit>().searchUsers(q);
                      }
                    },
                  );
                }

                if (users.isSuccess && (users.data?.isEmpty ?? true)) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          PhosphorIcons.userCircleFill,
                          size: 56,
                          color: AppColors.labelSecondary.withValues(alpha: 0.25),
                        ),
                        AppDimens.h12.hSpace,
                        Text(
                          'Pengguna tidak ditemukan',
                          style: context.textStyle.titleSmall?.copyWith(
                            color: AppColors.labelSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.w16,
                    vertical: AppDimens.h8,
                  ),
                  itemCount: users.data?.length ?? 0,
                  separatorBuilder: (_, __) => AppDimens.h12.hSpace,
                  itemBuilder: (context, index) {
                    final user = users.data![index];
                    return _buildUserCard(context, user);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, ChatParticipantEntity user) {
    final avatar = user.urlFoto ?? '';
    final name = user.name ?? 'Unknown User';
    final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return AppCard(
      onTap: () => _openPrivateConversation(context, user),
      showHeaderDivider: false,
      header: Row(
        children: [
          CircleAvatar(
            radius: AppDimens.r20,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
            child: avatar.isEmpty
                ? Text(
                    firstLetter,
                    style: context.textStyle.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          SizedBox(width: AppDimens.w12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyle.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelPrimary,
                  ),
                ),
                if (user.username != null && user.username!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    '@${user.username}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyle.bodySmall?.copyWith(
                      color: AppColors.labelSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            PhosphorIcons.chatCircleDots,
            size: 22,
            color: AppColors.primary,
          ),
        ],
      ),
      content: const SizedBox.shrink(),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.w16,
        vertical: AppDimens.h14,
      ),
    );
  }

  Future<void> _openPrivateConversation(
    BuildContext context,
    ChatParticipantEntity user,
  ) async {
    final userId = user.id;
    if (userId == null || userId.isEmpty) {
      AppSnackbar.showError(context, 'Pengguna tidak valid.');
      return;
    }

    final result = await sl<ChatGetOrCreatePrivateConversationUseCase>()(userId);
    if (!context.mounted) return;

    result.fold(
      (failure) => AppSnackbar.showError(context, failure.message),
      (conversation) {
        final conversationId = conversation.id;
        if (conversationId == null || conversationId.isEmpty) {
          AppSnackbar.showError(context, 'Percakapan tidak dapat dibuat.');
          return;
        }
        context.router.push(ChatRoomPageRoute(
          conversationId: conversationId,
          chatTitle: user.name ?? user.username ?? 'Percakapan',
          chatAvatar: user.urlFoto ?? '',
        ));
      },
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.w16,
        vertical: AppDimens.h14,
      ),
      child: Row(
        children: [
          AppShimmer.circle(size: 40),
          SizedBox(width: AppDimens.w12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer.box(width: 120, height: 14),
                const SizedBox(height: 6),
                AppShimmer.box(width: 80, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
