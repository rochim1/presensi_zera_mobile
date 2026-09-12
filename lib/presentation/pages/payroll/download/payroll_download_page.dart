import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

@RoutePage()
class PayrollDownloadPage extends StatefulWidget {
  const PayrollDownloadPage({super.key});

  @override
  State<PayrollDownloadPage> createState() => _PayrollDownloadPageState();
}

class _PayrollDownloadPageState extends State<PayrollDownloadPage> {
  List<FileSystemEntity> _files = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() => _isLoading = true);
    try {
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        final slipDir = Directory('${directory.path}/SlipGaji');
        if (await slipDir.exists()) {
          final files = slipDir.listSync().whereType<File>().toList();
          // Sort by last modified descending
          files.sort(
            (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
          );
          setState(() {
            _files = files;
          });
        }
      }
    } catch (e) {
      debugPrint('Failed to load files: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openFile(File file) async {
    if (!await file.exists() || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => PayrollPdfViewerPage(file: file)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(
        title: 'Unduhan Slip Gaji',
        backgroundColor: AppColors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _files.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadFiles,
              child: ListView.separated(
                padding: EdgeInsets.all(AppDimens.w16),
                itemCount: _files.length,
                separatorBuilder: (context, index) => AppDimens.h12.hSpace,
                itemBuilder: (context, index) {
                  final file = _files[index] as File;
                  final fileName = file.path.split(Platform.pathSeparator).last;
                  final lastModified = file.lastModifiedSync();

                  return Material(
                    color: AppColors.white,
                    elevation: 2,
                    shadowColor: Colors.black.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppDimens.r12),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppDimens.w16,
                        vertical: AppDimens.h8,
                      ),
                      leading: Container(
                        padding: EdgeInsets.all(AppDimens.w12),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          PhosphorIcons.filePdf,
                          color: AppColors.danger,
                          size: AppDimens.w24,
                        ),
                      ),
                      title: Text(
                        fileName,
                        style: context.theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        _formatDate(lastModified),
                        style: context.theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.labelSecondary,
                        ),
                      ),
                      trailing: Icon(
                        PhosphorIcons.caretRight,
                        size: AppDimens.w20,
                        color: AppColors.labelSecondary,
                      ),
                      onTap: () => _openFile(file),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.folderOpen,
            size: AppDimens.w64,
            color: AppColors.labelSecondary.withValues(alpha: 0.5),
          ),
          AppDimens.h16.hSpace,
          Text(
            'Belum ada slip gaji yang diunduh',
            style: context.theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.labelSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class PayrollPdfViewerPage extends StatelessWidget {
  final File file;

  const PayrollPdfViewerPage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final fileName = file.path.split(Platform.pathSeparator).last;
    return Scaffold(
      appBar: AppTopBar(
        title: fileName,
        backgroundColor: AppColors.transparent,
      ),
      body: PDFView(
        filePath: file.path,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onError: (error) {
          AppSnackbar.showError(context, 'PDF tidak dapat dibuka: $error');
        },
        onPageError: (page, error) {
          AppSnackbar.showError(
            context,
            'Halaman ${page ?? 0} tidak dapat ditampilkan',
          );
        },
      ),
    );
  }
}
