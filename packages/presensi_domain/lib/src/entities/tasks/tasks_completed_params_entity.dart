import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class JadwalPembayaranParamsEntity extends Equatable {
  final int? noTermin;
  final String? dueDate;
  final double? amount;

  const JadwalPembayaranParamsEntity({
    this.noTermin,
    this.dueDate,
    this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      if (noTermin != null) "no_termin": noTermin,
      if (dueDate != null) "due_date": dueDate,
      if (amount != null) "amount": amount,
    };
  }

  @override
  List<Object?> get props => [noTermin, dueDate, amount];
}

class TasksCompletedParamsEntity extends Equatable {
  /// please use `StatusTask`
  final String? statusTask;
  final String? completedTime;
  final String? note;
  final String? taskId;
  final String? aktivitasId;

  /// clear nullable in array
  final List<GlobalImageParamsEntity>? fotoBukti;
  final List<int>? fotoIndexing;
  final LocationEntity? lokasi;

  final String? tipeCall;
  final String? kategoriOrder;
  final String? metodePembayaran;
  final double? orderValue;
  final List<String>? noReferensi;
  final List<JadwalPembayaranParamsEntity>? jadwalPembayaran;
  final bool? isLembur;

  const TasksCompletedParamsEntity({
    this.statusTask,
    this.completedTime,
    this.note,
    this.taskId,
    this.aktivitasId,
    this.fotoBukti,
    this.fotoIndexing,
    this.lokasi,
    this.tipeCall,
    this.kategoriOrder,
    this.metodePembayaran,
    this.orderValue,
    this.noReferensi,
    this.jadwalPembayaran,
    this.isLembur,
  });

  @override
  List<Object?> get props {
    return [
      statusTask,
      completedTime,
      note,
      taskId,
      aktivitasId,
      fotoBukti,
      fotoIndexing,
      lokasi,
      tipeCall,
      kategoriOrder,
      metodePembayaran,
      orderValue,
      noReferensi,
      jadwalPembayaran,
      isLembur,
    ];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "input": {
        "status_task": statusTask,
        "completed_time": completedTime,
        'lokasi': lokasi?.toJson(),
        "note": note,
        "foto_indexing": fotoIndexing,
        if (tipeCall != null) "tipe_call": tipeCall,
        if (kategoriOrder != null) "kategori_order": kategoriOrder,
        if (metodePembayaran != null) "metode_pembayaran": metodePembayaran,
        if (orderValue != null) "order_value": orderValue,
        if (noReferensi != null) "no_referensi": noReferensi,
        if (jadwalPembayaran != null) "jadwal_pembayaran": jadwalPembayaran?.map((e) => e.toJson()).toList(),
        if (isLembur != null) "is_lembur": isLembur,
      },
      "fotoBukti": fotoBukti?.map((e) => e.file).toList(),
      "id": taskId,
      "aktivitasId": aktivitasId,
    };
  }
}
