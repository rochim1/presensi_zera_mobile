import 'package:presensi_data/presensi_data.dart';

void main() {
  final converter = TimeConverter();
  
  final res1 = converter.fromJson('17:00:00');
  print('Result for 17:00:00 is: $res1');
  
  final res2 = converter.fromJson('17:00');
  print('Result for 17:00 is: $res2');
}
