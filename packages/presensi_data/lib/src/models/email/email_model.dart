import 'package:presensi_domain/presensi_domain.dart';

class EmailModel extends EmailEntity {
  const EmailModel({
    super.id,
    super.title,
    super.tipeEmail,
    super.body,
    super.isRead,
    super.isDraft,
    super.isStarred,
    super.isArchived,
    super.isTrash,
    super.sentBatchId,
    super.recipientType,
    super.tanggalEmail,
    super.createdAt,
    super.userId,
    super.senderId,
    super.instansiId,
  });

  factory EmailModel.fromJson(Map<String, dynamic> json) {
    return EmailModel(
      id: json['_id'],
      title: json['title'],
      tipeEmail: json['tipe_email'],
      body: json['body'],
      isRead: json['is_read'],
      isDraft: json['is_draft'],
      isStarred: json['is_starred'],
      isArchived: json['is_archived'],
      isTrash: json['is_trash'],
      sentBatchId: json['sent_batch_id'],
      recipientType: json['recipient_type'],
      tanggalEmail: json['tanggal_email'],
      createdAt: json['createdAt'],
      userId: json['user_id'] != null
          ? EmailUserModel.fromJson(json['user_id'])
          : null,
      senderId: json['sender_id'] != null
          ? EmailUserModel.fromJson(json['sender_id'])
          : null,
      instansiId: json['instansi_id'] != null
          ? EmailInstansiModel.fromJson(json['instansi_id'])
          : null,
    );
  }
}

class EmailUserModel extends EmailUserEntity {
  const EmailUserModel({super.id, super.name, super.email, super.urlFoto});

  factory EmailUserModel.fromJson(Map<String, dynamic> json) {
    return EmailUserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      urlFoto: json['url_foto'],
    );
  }
}

class EmailInstansiModel extends EmailInstansiEntity {
  const EmailInstansiModel({super.id, super.namaInstansi});

  factory EmailInstansiModel.fromJson(Map<String, dynamic> json) {
    return EmailInstansiModel(
      id: json['_id'],
      namaInstansi: json['nama_instansi'],
    );
  }
}
