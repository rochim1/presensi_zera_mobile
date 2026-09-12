mixin KalenderGraphQl {
  String get createKalenderEvent => r'''
mutation CreateKalenderEvent($input: KalenderEventInput!) {
  CreateKalenderEvent(input: $input) { _id title start_date }
}''';
  String get updateKalenderEvent => r'''
mutation UpdateKalenderEvent($id: ID!, $input: KalenderEventUpdateInput!) {
  UpdateKalenderEvent(_id: $id, input: $input) { _id title }
}''';
  String get deleteKalenderEvent => r'''
mutation DeleteKalenderEvent($id: ID!) {
  DeleteKalenderEvent(_id: $id) { _id }
}''';

  String get getKalenderEventsByDateRange =>
      r'''query GetKalenderEventsByDateRange($startDate: String!, $endDate: String!) {
  GetKalenderEventsByDateRange(start_date: $startDate, end_date: $endDate) {
    _id
    title
    description
    start_date
    end_date
    start_time
    end_time
    all_day
    event_type
    color
    is_recurring
    recurring_type
    status
    attendance_enabled
    attendance_open_at
    attendance_close_at
    attendance_location_name
    attendance_latitude
    attendance_longitude
    attendance_radius_meters
  }
}''';

  String get getEventAttendanceQuery => r'''
query GetEventAttendance($eventId: ID!) {
  GetEventAttendance(event_id: $eventId) {
    _id
    check_in_at
    user_id { _id name username nip no_identitas }
  }
}''';

  String get getEventAttendanceQrQuery => r'''
query GetEventAttendanceQr($eventId: ID!) {
  GetEventAttendanceQr(event_id: $eventId) {
    token issued_at expires_at refresh_in_seconds
  }
}''';

  String get checkInEventByQrMutation => r'''
mutation CheckInEventByQr($qrToken: String!, $latitude: Float, $longitude: Float) {
  CheckInEventByQr(qr_token: $qrToken, latitude: $latitude, longitude: $longitude) {
    message
    attendance { _id check_in_at user_id { _id name username nip no_identitas } }
  }
}''';

  String get scanEventAttendanceMutation => r'''
mutation ScanEventAttendance($eventId: ID!, $qrToken: String!, $latitude: Float, $longitude: Float) {
  ScanEventAttendance(event_id: $eventId, qr_token: $qrToken, scanner_latitude: $latitude, scanner_longitude: $longitude) {
    message
    attendance { _id check_in_at user_id { _id name username nip no_identitas } }
  }
}''';
}
