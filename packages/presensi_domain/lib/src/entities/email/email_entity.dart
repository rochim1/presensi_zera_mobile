import 'package:equatable/equatable.dart';

class EmailEntity extends Equatable {
  final String? id;
  final String? title;
  final String? tipeEmail;
  final String? body;
  final bool? isRead;
  final bool? isDraft;
  final bool? isStarred;
  final bool? isArchived;
  final bool? isTrash;
  final String? sentBatchId;
  final String? recipientType;
  final String? tanggalEmail;
  final String? createdAt;
  final EmailUserEntity? userId;
  final EmailUserEntity? senderId;
  final EmailInstansiEntity? instansiId;

  const EmailEntity({
    this.id,
    this.title,
    this.tipeEmail,
    this.body,
    this.isRead,
    this.isDraft,
    this.isStarred,
    this.isArchived,
    this.isTrash,
    this.sentBatchId,
    this.recipientType,
    this.tanggalEmail,
    this.createdAt,
    this.userId,
    this.senderId,
    this.instansiId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    tipeEmail,
    body,
    isRead,
    isDraft,
    isStarred,
    isArchived,
    isTrash,
    sentBatchId,
    recipientType,
    tanggalEmail,
    createdAt,
    userId,
    senderId,
    instansiId,
  ];
}

class EmailUserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? urlFoto;

  const EmailUserEntity({this.id, this.name, this.email, this.urlFoto});

  @override
  List<Object?> get props => [id, name, email, urlFoto];
}

class EmailInstansiEntity extends Equatable {
  final String? id;
  final String? namaInstansi;

  const EmailInstansiEntity({this.id, this.namaInstansi});

  @override
  List<Object?> get props => [id, namaInstansi];
}
