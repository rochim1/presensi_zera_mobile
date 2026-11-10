// Read-only scan: reports source copy outside explicit localization calls.
import 'dart:convert';
import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'inventory_ui_text.dart' as inventory;

class Audit extends inventory.Strings {
  Audit(super.path, super.source);
  @override
  void record(StringLiteral node, String text) {
    for (AstNode? p = node.parent; p != null; p = p.parent) {
      if (p is MethodInvocation && ['tr', 'trCurrent', 'HrText'].contains(p.methodName.name)) return;
      if (p is InstanceCreationExpression && p.constructorName.type.toSource() == 'HrText') return;
    }
    super.record(node, text);
  }
}

void main() {
  var files = 0;
  final warnings = <String>[];
  for (final root in ['lib', 'packages/presensi_data/lib', 'packages/presensi_domain/lib']) {
    for (final file in Directory(root).listSync(recursive: true).whereType<File>()) {
      final path = file.path.replaceAll('\\', '/');
      if (!path.endsWith('.dart') || path.contains('/l10n/') || RegExp(r'\.(g|gr|freezed)\.dart$').hasMatch(path)) continue;
      files++;
      final source = file.readAsStringSync();
      final parsed = parseString(content: source, throwIfDiagnostics: false);
      if (parsed.errors.isNotEmpty) warnings.add(path);
      parsed.unit.accept(Audit(path, source));
    }
  }
  final out = Directory('../output/hr-translation-rescan-20261109')..createSync(recursive: true);
  File('${out.path}/candidates.json').writeAsStringSync(const JsonEncoder.withIndent('  ').convert({
    'files': files, 'parseWarnings': warnings, 'rows': inventory.rows,
  }));
  print('Scanned $files source files; ${inventory.rows.length} unlocalized candidate locations; ${warnings.length} parse warnings.');
}
