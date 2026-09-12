import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/bloc/chat/chat_create_group_cubit.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

@RoutePage()
class ChatCreateGroupPage extends StatefulWidget implements AutoRouteWrapper {
  const ChatCreateGroupPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatCreateGroupCubit>(),
      child: this,
    );
  }

  @override
  State<ChatCreateGroupPage> createState() => _ChatCreateGroupPageState();
}

class _ChatCreateGroupPageState extends State<ChatCreateGroupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ChatCreateGroupCubit>().searchUsers('');
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCreateGroupCubit, ChatCreateGroupState>(
      listenWhen: (prev, current) => prev.createStatus != current.createStatus,
      listener: (context, state) {
        final createStatus = state.createStatus;
        if (createStatus.isLoading) {
          SmartDialog.showLoading();
        } else if (createStatus.isError) {
          SmartDialog.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(createStatus.failure?.message ?? 'Gagal membuat grup')),
          );
        } else if (createStatus.isSuccess) {
          SmartDialog.dismiss();
          final data = createStatus.data;
          if (data != null && data.id != null) {
            context.router.popUntil((route) => route.settings.name == ChatListPageRoute.name);
            context.router.push(ChatRoomPageRoute(
              conversationId: data.id!,
              chatTitle: data.groupName ?? 'Grup Baru',
              chatAvatar: data.groupAvatar ?? '',
            ));
          } else {
            context.router.maybePop(true);
          }
        }
      },
      child: Scaffold(
        appBar: AppTopBar(
          title: 'Buat Grup Baru',
          backgroundColor: AppColors.transparent,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Info Form
                    Container(
                      padding: EdgeInsets.all(AppDimens.h16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border(bottom: BorderSide(color: AppColors.dividerLight)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                child: Icon(PhosphorIcons.camera, color: AppColors.primary),
                              ),
                              SizedBox(width: AppDimens.w16),
                              Expanded(
                                child: TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    hintText: 'Nama Grup (Wajib)',
                                    hintStyle: context.textStyle.bodyMedium?.copyWith(color: AppColors.labelSecondary),
                                    border: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderGrey)),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderGrey)),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                                  ),
                                  style: context.textStyle.titleMedium,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppDimens.h16),
                          TextField(
                            controller: _descController,
                            decoration: InputDecoration(
                              hintText: 'Deskripsi Grup (Opsional)',
                              hintStyle: context.textStyle.bodyMedium?.copyWith(color: AppColors.labelSecondary),
                              border: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderGrey)),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderGrey)),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                            ),
                            style: context.textStyle.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    
                    // Header Pilih Anggota
                    Padding(
                      padding: EdgeInsets.fromLTRB(AppDimens.w16, AppDimens.h24, AppDimens.w16, AppDimens.h8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pilih Anggota',
                            style: context.textStyle.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          BlocBuilder<ChatCreateGroupCubit, ChatCreateGroupState>(
                            builder: (context, state) {
                              return Text(
                                '${state.selectedUsers.length} Dipilih',
                                style: context.textStyle.labelSmall?.copyWith(color: AppColors.primary),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // User List
                    BlocBuilder<ChatCreateGroupCubit, ChatCreateGroupState>(
                      builder: (context, state) {
                        final users = state.users;

                        if (users.isLoading) {
                          return Padding(
                            padding: EdgeInsets.all(AppDimens.h16),
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (users.isError) {
                          return Padding(
                            padding: EdgeInsets.all(AppDimens.h16),
                            child: Center(
                              child: Text(
                                'Gagal memuat pengguna',
                                style: context.textStyle.bodySmall?.copyWith(color: AppColors.danger),
                              ),
                            ),
                          );
                        }

                        final userList = users.data ?? [];
                        if (userList.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.all(AppDimens.h16),
                            child: Center(
                              child: Text(
                                'Tidak ada pengguna tersedia',
                                style: context.textStyle.bodySmall?.copyWith(color: AppColors.labelSecondary),
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: userList.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.dividerLight),
                          itemBuilder: (context, index) {
                            final user = userList[index];
                            final isSelected = state.selectedUsers.any((u) => u.id == user.id);
                            final avatar = user.urlFoto ?? '';
                            final name = user.name ?? 'Unknown User';
                            final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';

                            return ListTile(
                              onTap: () {
                                context.read<ChatCreateGroupCubit>().toggleUserSelection(user);
                              },
                              contentPadding: EdgeInsets.symmetric(horizontal: AppDimens.w16, vertical: 4),
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                                    backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
                                    child: avatar.isEmpty
                                        ? Text(
                                            firstLetter,
                                            style: context.textStyle.titleSmall?.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : null,
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: AppColors.white, width: 1.5),
                                        ),
                                        child: Icon(Icons.check, size: 12, color: AppColors.white),
                                      ),
                                    ),
                                ],
                              ),
                              title: Text(
                                name,
                                style: context.textStyle.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.labelPrimary,
                                ),
                              ),
                              subtitle: user.username != null ? Text(
                                '@${user.username}',
                                style: context.textStyle.labelSmall?.copyWith(
                                  color: AppColors.labelSecondary,
                                ),
                              ) : null,
                              trailing: Checkbox(
                                value: isSelected,
                                onChanged: (_) {
                                  context.read<ChatCreateGroupCubit>().toggleUserSelection(user);
                                },
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Action
            Container(
              padding: EdgeInsets.all(AppDimens.h16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: BlocBuilder<ChatCreateGroupCubit, ChatCreateGroupState>(
                builder: (context, state) {
                  final isButtonEnabled = state.selectedUsers.isNotEmpty && _nameController.text.trim().isNotEmpty;
                  return AppButton(
                    onPressed: isButtonEnabled ? () {
                      context.read<ChatCreateGroupCubit>().createGroup(
                        groupName: _nameController.text,
                        groupDescription: _descController.text,
                      );
                    } : () {},
                    text: 'Buat Grup',
                    colors: isButtonEnabled ? [AppColors.primary, AppColors.primary] : [AppColors.borderGrey, AppColors.borderGrey],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
