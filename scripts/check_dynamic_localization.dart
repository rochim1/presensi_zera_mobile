import 'dart:io';
import 'dart:convert';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
final strings=<String>{}; final dynamicRows=<Map>[]; String currentPath="";
class V extends RecursiveAstVisitor<void>{
 void add(ArgumentList a){if(a.arguments.isNotEmpty && a.arguments.first is! SimpleStringLiteral)dynamicRows.add({"file":currentPath,"expression":a.arguments.first.toSource(),"offset":a.offset});if(a.arguments.isNotEmpty && a.arguments.first is SimpleStringLiteral)strings.add((a.arguments.first as SimpleStringLiteral).value);}
 @override void visitInstanceCreationExpression(InstanceCreationExpression n){if(n.constructorName.type.toSource()=='Text')add(n.argumentList);super.visitInstanceCreationExpression(n);}
 @override void visitMethodInvocation(MethodInvocation n){if(n.target==null && n.methodName.name=='Text')add(n.argumentList);super.visitMethodInvocation(n);}
}
void main(){for(final f in Directory('lib/presentation').listSync(recursive:true).whereType<File>().where((f)=>f.path.endsWith('.dart'))){currentPath=f.path.replaceAll('\\','/');parseString(content:f.readAsStringSync(),throwIfDiagnostics:false).unit.accept(V());}final a=strings.toList()..sort();File('../output/hr-translation-rescan-20261109/remaining-static-text.json').writeAsStringSync(JsonEncoder.withIndent('  ').convert(a));File('../output/hr-translation-rescan-20261109/remaining-dynamic-text.json').writeAsStringSync(JsonEncoder.withIndent('  ').convert(dynamicRows));print('${a.length} static labels, ${dynamicRows.length} dynamic Text expressions for review.');}
