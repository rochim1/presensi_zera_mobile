import 'package:presensi_data/presensi_data.dart';

abstract class KalenderRemoteDatasource {
  Future<void> createEvent(Map<String, dynamic> input);
  Future<void> updateEvent(String id, Map<String, dynamic> input);
  Future<void> deleteEvent(String id);
  Future<List<EventAttendance>> getEventAttendance(String eventId);
  Future<Map<String, dynamic>> getEventAttendanceQr(String eventId);
  Future<String> checkInEventByQr({
    required String qrToken,
    double? latitude,
    double? longitude,
  });
  Future<String> scanEventAttendance({
    required String eventId,
    required String qrToken,
    double? latitude,
    double? longitude,
  });

  Future<List<KalenderEvent>> getEventsByDateRange(
    String startDate,
    String endDate,
  );
}

class KalenderRemoteDatasourceImpl
    with KalenderGraphQl
    implements KalenderRemoteDatasource {
  final GraphQlService gql;

  KalenderRemoteDatasourceImpl({required this.gql});

  @override
  Future<void> createEvent(Map<String, dynamic> input) async {
    await gql.mutation(
      mutation: createKalenderEvent,
      variables: {'input': input},
    );
  }

  @override
  Future<void> updateEvent(String id, Map<String, dynamic> input) async {
    await gql.mutation(
      mutation: updateKalenderEvent,
      variables: {'id': id, 'input': input},
    );
  }

  @override
  Future<void> deleteEvent(String id) async {
    await gql.mutation(mutation: deleteKalenderEvent, variables: {'id': id});
  }

  @override
  Future<List<KalenderEvent>> getEventsByDateRange(
    String startDate,
    String endDate,
  ) async {
    final response = await gql.query(
      query: getKalenderEventsByDateRange,
      variables: {'startDate': startDate, 'endDate': endDate},
    );

    final events = response['GetKalenderEventsByDateRange'] as List<dynamic>;
    return events.map((e) => KalenderEvent.fromJson(e)).toList();
  }

  @override
  Future<List<EventAttendance>> getEventAttendance(String eventId) async {
    final response = await gql.query(
      query: getEventAttendanceQuery,
      variables: {'eventId': eventId},
    );
    final rows = response['GetEventAttendance'] as List<dynamic>? ?? const [];
    return rows
        .map((row) => EventAttendance.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> getEventAttendanceQr(String eventId) async {
    final response = await gql.query(
      query: getEventAttendanceQrQuery,
      variables: {'eventId': eventId},
    );
    return Map<String, dynamic>.from(
      response['GetEventAttendanceQr'] as Map? ?? const {},
    );
  }

  @override
  Future<String> checkInEventByQr({
    required String qrToken,
    double? latitude,
    double? longitude,
  }) async {
    final response = await gql.mutation(
      mutation: checkInEventByQrMutation,
      variables: {
        'qrToken': qrToken,
        'latitude': latitude,
        'longitude': longitude,
      },
    );
    return response['CheckInEventByQr']?['message']?.toString() ??
        'Kehadiran kegiatan berhasil dicatat';
  }

  @override
  Future<String> scanEventAttendance({
    required String eventId,
    required String qrToken,
    double? latitude,
    double? longitude,
  }) async {
    final response = await gql.mutation(
      mutation: scanEventAttendanceMutation,
      variables: {
        'eventId': eventId,
        'qrToken': qrToken,
        'latitude': latitude,
        'longitude': longitude,
      },
    );
    return response['ScanEventAttendance']?['message']?.toString() ??
        'Kehadiran berhasil dicatat';
  }
}
