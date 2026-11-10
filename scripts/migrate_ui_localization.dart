import 'dart:convert';
import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

final catalog = (jsonDecode(File('../output/hr-translation-20261109/translations.json').readAsStringSync())['entries'] as List).cast<Map>();
final texts = catalog.map((e) => e['sourceText'] as String).toSet()..addAll((jsonDecode(File('lib/l10n/app_id.arb').readAsStringSync()) as Map).entries.where((e)=>!e.key.toString().startsWith('@') && e.value is String).map((e)=>e.value as String));
class Edit { Edit(this.start,this.end,this.value); final int start,end; final String value; }
class Migration extends RecursiveAstVisitor<void> {
  Migration(this.source,this.path);
  final String source,path;
  final edits=<String,Edit>{};
  int rendered=0, labels=0;
  void edit(int start,int end,String value) => edits['$start:$end']=Edit(start,end,value);
  String? literal(Expression node) {
    if(node is SimpleStringLiteral)return node.value;
    if(node is StringInterpolation){var i=0;return node.elements.map((e)=>e is InterpolationString?e.value:'{nilai${++i}}').join();}
    if(node is AdjacentStrings)return node.strings.map((s)=>literal(s)??'').join();
    return null;
  }
  bool uiText(Expression arg) {
    if(arg is PostfixExpression && arg.operator.lexeme=='!')return uiText(arg.operand);
    final raw=literal(arg);
    if(raw!=null)return texts.contains(raw);
    if(arg is BinaryExpression && arg.operator.lexeme=='??')return uiText(arg.leftOperand) || uiText(arg.rightOperand);
    if(arg is ConditionalExpression)return uiText(arg.thenExpression) || uiText(arg.elseExpression);
    final code=arg.toSource();
    if(code=='_progress')return true;
    if(RegExp(r'(getStatusLabel|statusLabel|statusText|\.label$|\.labelName$)').hasMatch(code))return true;
    if(RegExp(r'^k(Msg|MapWaiting|DfltCapCamera|EmptyValidator|NotSelectedValidator|IsDuplicateValidator|NotWrongValidatior|NotMatch|MoreTask|MoreWork|CompleteTask|NotTask|IsCutiToday|NotCheckIn|NotifDel|AddressNotFound|WhenWrong|SuccessCapture|FailedCapture|FaceDetected|FaceNotDetected|CameraNotFound)').hasMatch(code))return true;
    if(RegExp(r'(^|\.)(failure\??\.message|errorMessage|errorText|error|_error)$').hasMatch(code))return true;
    if(path.contains('/widgets/') && RegExp(r'^(widget\.)?(title|subtitle|subTitle|label|hint|hintText|description|message|text|contentTitle|contentSubtitle|yesOkLabel|noCancelLabel|labelCancel|labelYesOk|actionButtonLabel|secondaryActionButtonLabel|sliderText)$').hasMatch(code))return true;
    return false;
  }
  void textCall(Expression node,ArgumentList args,int nameOffset){
    final positional=args.arguments.where((a)=>a is! NamedExpression).firstOrNull;
    if(positional==null || !uiText(positional))return;
    edit(nameOffset,nameOffset+4,'HrText');rendered++;
    if(path.contains('/login/') && literal(positional)=='Masuk')edit(positional.end,positional.end,', signIn: true');
  }
  String? contextFor(AstNode node){
    ClassDeclaration? klass;
    for(AstNode? p=node.parent;p!=null;p=p.parent){
      if(p is MethodDeclaration){
        if(p.isStatic)return null;
        final match=RegExp(r'\bBuildContext\s+(\w+)').firstMatch(p.parameters?.toSource()??'');
        if(match!=null)return match.group(1);
      }
      if(p is FunctionExpression){
        final match=RegExp(r'\bBuildContext\s+(\w+)').firstMatch(p.parameters?.toSource()??'');
        if(match!=null)return match.group(1);
        for(final name in ['context','ctx','ctxAvatar']){
          if(RegExp('\\b$name\\b').hasMatch(p.parameters?.toSource()??''))return name;
        }
      }
      if(p is FunctionDeclaration){
        final match=RegExp(r'\bBuildContext\s+(\w+)').firstMatch(p.functionExpression.parameters?.toSource()??'');
        if(match!=null)return match.group(1);
      }
      if(p is ClassDeclaration){klass=p;break;}
    }
    // Only State methods have an implicit BuildContext; never field initializers.
    if(klass?.extendsClause?.superclass.toSource().startsWith('State<')==true){
      for(AstNode? p=node.parent;p!=null && p!=klass;p=p.parent){if(p is MethodDeclaration && !p.isStatic)return 'context';}
    }
    return null;
  }
  bool removeConst(AstNode node){
    final tokens=<dynamic>[];
    for(AstNode? p=node.parent;p!=null;p=p.parent){
      if(p is VariableDeclarationList && p.isConst)return false;
      if(p is InstanceCreationExpression && p.keyword?.lexeme=='const')tokens.add(p.keyword);
      if(p is TypedLiteral && p.constKeyword!=null)tokens.add(p.constKeyword);
      if(p is MethodDeclaration || p is FunctionDeclaration)break;
    }
    for(final t in tokens)edit(t.offset as int,(t.offset+t.length) as int,'');
    return true;
  }
  @override void visitMethodInvocation(MethodInvocation node){
    if(node.target==null && node.methodName.name=='Text')textCall(node,node.argumentList,node.methodName.offset);
    super.visitMethodInvocation(node);
  }
  @override void visitInstanceCreationExpression(InstanceCreationExpression node){
    if(node.constructorName.type.toSource()=='Text' && node.constructorName.name==null)textCall(node,node.argumentList,node.constructorName.type.offset);
    super.visitInstanceCreationExpression(node);
  }
  @override void visitNamedExpression(NamedExpression node){
    const names={'title','subtitle','subTitle','label','hint','hintText','labelText','helperText','errorText','message','description','tooltip','semanticLabel','semanticsLabel','contentTitle','contentSubtitle','yesOkLabel','noCancelLabel','emptyText','emptyMessage','buttonText','titleText','caption'};
    final value=literal(node.expression);
    if((names.contains(node.name.label.name) || (node.name.label.name=='text' && node.parent?.parent?.toSource().startsWith('TextSpan(')==true)) && value!=null && texts.contains(value)){
      final ctx=contextFor(node);
      if(ctx!=null && removeConst(node)){
        edit(node.expression.offset,node.expression.end,'(${node.expression.toSource()}).tr($ctx)');labels++;
      }
    }
    super.visitNamedExpression(node);
  }
}
void main(){
  final report=<Map>[];
  for(final f in Directory('lib').listSync(recursive:true).whereType<File>()){
    final path=f.path.replaceAll('\\','/');
    if(!path.endsWith('.dart') || path.contains('/l10n/') || RegExp(r'\.(g|gr|freezed)\.dart$').hasMatch(path) || (!path.contains('/presentation/') && path!='lib/app.dart'))continue;
    final source=f.readAsStringSync();final parsed=parseString(content:source,throwIfDiagnostics:false);final migration=Migration(source,path);parsed.unit.accept(migration);
    if(migration.edits.isEmpty)continue;
    var updated=source;
    final edits=migration.edits.values.toList()..sort((a,b)=>b.start.compareTo(a.start));
    for(final edit in edits)updated=updated.replaceRange(edit.start,edit.end,edit.value);
    if(!updated.contains('part of ') && !updated.contains("import 'package:presensi_mobile/l10n/hr_localization.dart';"))updated="import 'package:presensi_mobile/l10n/hr_localization.dart';\n$updated";
    f.writeAsStringSync(updated);
    report.add({'file':path,'localizedTextWidgets':migration.rendered,'localizedArguments':migration.labels});
  }
  File('../output/hr-translation-20261109/migration-final.json').writeAsStringSync(const JsonEncoder.withIndent('  ').convert(report));
  print('Localized ${report.length} presentation files.');
}

