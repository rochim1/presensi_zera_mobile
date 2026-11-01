import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  test('Pantoo common illustrations decode and render in Flutter', () async {
    const names = ['confirmation', 'empty_list', 'lost_connection', 'something_wrong', 'successfully'];
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.drawColor(const ui.Color(0xFFF8FAF9), ui.BlendMode.src);
    for (var i = 0; i < names.length; i++) {
      final source = File('assets/common/${names[i]}.svg').readAsStringSync();
      final picture = await vg.loadPicture(SvgStringLoader(source), null);
      expect(picture.size, const ui.Size(200, 200));
      canvas.save();
      canvas.translate((i % 3) * 220.0 + 10, (i ~/ 3) * 220.0 + 10);
      canvas.drawPicture(picture.picture);
      canvas.restore();
      picture.picture.dispose();
    }
    final sheet = recorder.endRecording();
    final rendered = await sheet.toImage(660, 440);
    final bytes = await rendered.toByteData(format: ui.ImageByteFormat.png);
    expect(bytes, isNotNull);
    final output = File('build/common-assets-preview.png');
    output.parent.createSync(recursive: true);
    output.writeAsBytesSync(bytes!.buffer.asUint8List());
    rendered.dispose();
    sheet.dispose();
  });
}
