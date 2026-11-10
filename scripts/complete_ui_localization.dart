// Focused follow-up migration. Never changes API values or user data fields.
import 'dart:convert';
import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'migrate_ui_localization.dart' as base;

class Complete extends base.Migration {
  Complete(super.source, super.path);
  bool localized(Expression e) => e.toSource().contains('.tr(') || e.toSource().contains('.trCurrent(') || e.toSource().contains('hrLocale(');
  @override
  bool uiText(Expression arg) {
    if (localized(arg)) return false;
    if(path.endsWith('/app_request_card.dart') && ['title','title!','subtitle','subtitle!'].contains(arg.toSource()))return false;
    if(arg is BinaryExpression && arg.operator.lexeme=='??' && arg.leftOperand is! StringLiteral)return false;
    if (super.uiText(arg)) return true;
    final value=literal(arg);
    if(value!=null && base.texts.contains(value))return true;
    final raw=arg.toSource();
    if(raw=='title' && !path.contains('/chat/'))return true;
    if(['message','state.message','state.message!','state.successMessage!','f.message','locationError!','emptyMessage','availableText','badgeText','todayLabel','timeLabel','_pageTitle','state.type.title','statusTask.toName','type.toName','presenceType.toName','request.type.displayName','duration','summary','period','suffix','description',r'mood.$3','_formatJenisRequestLabel(jenis)','_getTypeLabel(stats[currentPage].typePresensi)','_scheduleStatus(schedule.status)','_getRunRateText(target.runRate)','getDurationLabel(leaveRequest!.tanggalIzin!, leaveRequest!.tanggalMasuk!, isHalfDay: leaveRequest!.isHalfDay == true)','_eventTypeLabels[e.key] ?? e.key'].contains(raw))return true;
    if(raw=='text' && (path.endsWith('/home_page.dart') || path.endsWith('/payroll_detail_page.dart')))return true;
    if((raw=='entry.value' || raw==r'status.$1') && path.endsWith('/activity_page.dart'))return true;
    if(raw=='e.value' && path.endsWith('/create_event_sheet.dart'))return true;
    if(arg is SwitchExpression && path.endsWith('/kalender_page.dart'))return true;
    final code = arg.toSource();
    return RegExp(r'^(widget\.)?(label|sublabel|subLabel|subtitle|subTitle|caption|hintText|emptyText|buttonLabel|cancelLabel|statusText|statusLabel|titleText|sliderText|actionButtonLabel|secondaryActionButtonLabel)!?$').hasMatch(code) ||
      RegExp(r'(getStatus(Text|Title|Label)|status(Text|Title|Label)|getSliderText|getActionButtonLabelText|getSecondaryActionButtonLabelText|\.displayLabel\b)', caseSensitive: false).hasMatch(code);
  }
  bool copyExpression(Expression e) {
    if(e is StringLiteral)return literal(e)!=null && base.texts.contains(literal(e));
    if(e is ConditionalExpression)return copyExpression(e.thenExpression) || copyExpression(e.elseExpression);
    if(e is BinaryExpression && e.operator.lexeme=='??')return copyExpression(e.leftOperand) || copyExpression(e.rightOperand);
    return false;
  }
  void wrap(Expression expression, String context, {bool nullable = false}) {
    if (localized(expression) || !removeConst(expression)) return;
    edit(expression.offset, expression.end, '(${expression.toSource()})${nullable ? '?' : ''}.tr($context)');
    labels++;
  }
  @override
  void visitNamedExpression(NamedExpression node) {
    final name = node.name.label.name;
    final ctx = contextFor(node);
    final expression = node.expression;
    final owner = node.parent?.parent;
    final inputDecoration = (owner is InstanceCreationExpression && owner.constructorName.type.toSource() == 'InputDecoration') || (owner is MethodInvocation && owner.methodName.name == 'InputDecoration');
    const copy = {'text','title','subtitle','label','hint','hintText','labelText','helperText','errorText','tooltip','helpText','semanticLabel','semanticsLabel','availableText','unavailableText','idleText','noDataText','failedText','canLoadingText','loadingText','refreshingText','completeText','canRefreshText','titleTime','contentValue'};
    if (ctx != null && !localized(expression)) {
      if (name == 'msg') {
        if(removeConst(expression)){edit(expression.offset,expression.end,'(${expression.toSource()}).trCurrent()');labels++;}
      } else if (copy.contains(name) && copyExpression(expression)) {
        wrap(expression, ctx);
      } else if (['errorText','hintText','labelText','helperText'].contains(name) && inputDecoration && expression.toSource() != 'null') {
        wrap(expression, ctx, nullable: true);
      }
    }
    super.visitNamedExpression(node);
  }
  bool inDisplayFormatter(AstNode node) {
    for(AstNode? p=node.parent;p!=null;p=p.parent){
      if(p is NamedExpression && p.name.label.name=='itemAsString')return true;
      if(p is MethodDeclaration)break;
    }
    return false;
  }
  @override
  void visitReturnStatement(ReturnStatement node){
    final e=node.expression;final ctx=contextFor(node);
    if(ctx!=null && e is StringLiteral && copyExpression(e) && inDisplayFormatter(node))wrap(e,ctx);
    super.visitReturnStatement(node);
  }
  @override
  void visitExpressionFunctionBody(ExpressionFunctionBody node){
    final ctx=contextFor(node);final e=node.expression;
    if(ctx!=null && e is StringLiteral && copyExpression(e) && inDisplayFormatter(node))wrap(e,ctx);
    super.visitExpressionFunctionBody(node);
  }
  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (RegExp(r'^_?(build|infoRow|detailRow|detailItem|infoItem|statItem|summaryItem|metaRow|detail|info|row)', caseSensitive: false).hasMatch(node.methodName.name)) {
      final ctx = contextFor(node);
      if (ctx != null) {
        for (final arg in node.argumentList.arguments) {
          if (arg is StringLiteral && literal(arg) != null && base.texts.contains(literal(arg))) wrap(arg, ctx);
        }
      }
    }
    super.visitMethodInvocation(node);
  }
}

void main() {
  base.texts.addAll((jsonDecode(File('lib/l10n/legacy_ui_aliases.json').readAsStringSync()) as Map).values.cast<String>());
  final report = <Map<String, Object>>[];
  for (final f in Directory('lib/presentation').listSync(recursive: true).whereType<File>()) {
    final path = f.path.replaceAll('\\', '/');
    if (!path.endsWith('.dart') || RegExp(r'\.(g|gr|freezed)\.dart$').hasMatch(path)) continue;
    final source = f.readAsStringSync();
    final migration = Complete(source, path);
    parseString(content: source, throwIfDiagnostics: false).unit.accept(migration);
    if (migration.edits.isEmpty) continue;
    var updated = source;
    final edits = migration.edits.values.toList()..sort((a,b) => b.start.compareTo(a.start));
    var previous = source.length + 1;
    for (final e in edits) {
      if (e.end > previous) throw StateError('Overlapping migration edits: $path');
      updated = updated.replaceRange(e.start, e.end, e.value);
      previous = e.start;
    }
    const import = "import 'package:presensi_mobile/l10n/hr_localization.dart';\n";
    if (!updated.contains('part of ') && !updated.contains(import.trim())) updated = import + updated;
    f.writeAsStringSync(updated);
    report.add({'file': path, 'textWidgets': migration.rendered, 'copyArguments': migration.labels});
  }
  File('../output/hr-translation-rescan-20261109/changes-third.json').writeAsStringSync(const JsonEncoder.withIndent('  ').convert(report));
  print('Completed UI localization in ${report.length} files.');
}
