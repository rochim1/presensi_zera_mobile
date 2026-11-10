// Keep dynamic data intact: localize UI fallback branches individually.
import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'migrate_ui_localization.dart' as base;

class Fallbacks extends base.Migration {
  Fallbacks(super.source, super.path);
  String render(Expression e, String context) {
    if(e is ParenthesizedExpression)return '(${render(e.expression,context)})';
    if(e is StringLiteral && literal(e)!=null && base.texts.contains(literal(e)))return '(${e.toSource()}).tr($context)';
    if(e is ConditionalExpression)return '${e.condition.toSource()} ? ${render(e.thenExpression,context)} : ${render(e.elseExpression,context)}';
    if(e is BinaryExpression && e.operator.lexeme=='??')return '${render(e.leftOperand,context)} ?? ${render(e.rightOperand,context)}';
    return e.toSource();
  }
  @override
  void visitMethodInvocation(MethodInvocation node){
    final target=node.target;
    if(node.methodName.name=='tr' && target is ParenthesizedExpression && node.argumentList.arguments.length==1 && (target.expression is ConditionalExpression || target.expression is BinaryExpression && (target.expression as BinaryExpression).operator.lexeme=='??')){
      final e=target.expression;
      edit(node.offset,node.end,'(${render(e,node.argumentList.arguments.first.toSource())})');
      return;
    }
    super.visitMethodInvocation(node);
  }
}
void main(){
  var changed=0;
  for(final f in Directory('lib/presentation').listSync(recursive:true).whereType<File>()){
    if(!f.path.endsWith('.dart') || RegExp(r'\.(g|gr|freezed)\.dart$').hasMatch(f.path))continue;
    final source=f.readAsStringSync();final m=Fallbacks(source,f.path);parseString(content:source,throwIfDiagnostics:false).unit.accept(m);
    if(m.edits.isEmpty)continue;
    var updated=source;final edits=m.edits.values.toList()..sort((a,b)=>b.start.compareTo(a.start));
    for(final e in edits)updated=updated.replaceRange(e.start,e.end,e.value);
    f.writeAsStringSync(updated);changed++;
  }
  print('Preserved dynamic data in $changed UI files.');
}
