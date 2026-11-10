import 'dart:convert';
import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
final known=<String>{...((jsonDecode(File('lib/l10n/legacy_ui_aliases.json').readAsStringSync()) as Map).values.cast<String>()),...((jsonDecode(File('lib/l10n/app_id.arb').readAsStringSync()) as Map).entries.where((e)=>!e.key.toString().startsWith('@')&&e.value is String).map((e)=>e.value as String))};
final rows=<Map>[];
class V extends RecursiveAstVisitor<void>{V(this.file);final String file;
 @override void visitSimpleStringLiteral(SimpleStringLiteral node){
 MethodDeclaration? method;for(AstNode? p=node.parent;p!=null;p=p.parent){if(p is MethodDeclaration){method=p;break;}}
 if(method!=null && RegExp(r'(label|title|description|toName|toDisplay|displayName|scheduleStatus)',caseSensitive:false).hasMatch(method.name.lexeme) && (node.parent is ReturnStatement || node.parent is ExpressionFunctionBody || (node.parent is SwitchExpressionCase && identical((node.parent as SwitchExpressionCase).expression,node))) && !known.contains(node.value) && RegExp(r'[A-Za-z]').hasMatch(node.value))rows.add({'source':node.value,'file':file,'method':method.name.lexeme});
 super.visitSimpleStringLiteral(node);
 }
}
void main(){for(final root in ['lib','packages/presensi_domain/lib']){for(final f in Directory(root).listSync(recursive:true).whereType<File>()){if(!f.path.endsWith('.dart')||f.path.contains('l10n')||RegExp(r'\.(g|gr|freezed)\.dart$').hasMatch(f.path))continue;parseString(content:f.readAsStringSync(),throwIfDiagnostics:false).unit.accept(V(f.path));}}File('../output/hr-translation-rescan-20261109/display-label-gaps.json').writeAsStringSync(JsonEncoder.withIndent('  ').convert(rows));}
