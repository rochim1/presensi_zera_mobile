import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/core/utils/pdf_web_launcher.dart';

@RoutePage()
class GlobalPdfViewerPage extends StatefulWidget {
  final String? base64String;

  const GlobalPdfViewerPage({super.key, this.base64String});

  @override
  State<GlobalPdfViewerPage> createState() => _GlobalPdfViewerPageState();
}

class _GlobalPdfViewerPageState extends State<GlobalPdfViewerPage>
    with WidgetsBindingObserver {
  final Completer<PDFViewController> pdfViewController =
      Completer<PDFViewController>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return sl<GlobalPdfViewerCubit>()
          ..getPermissionStatus(widget.base64String);
      },
      child: Scaffold(
        appBar: const AppBarWidget(titleText: 'Pdf Viewer'),
        body: Stack(
          children: [
            Container(
              height: AppDimens.bottomNavbarHeight,
              color: AppColors.primary,
            ),
            Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDimens.radiusLarge),
                ),
              ),
              child: BlocBuilder<GlobalPdfViewerCubit, GlobalPdfViewerState>(
                builder: (context, state) {
                  if (state.status.isLoaded) {
                    if (kIsWeb) {
                      return Center(
                        child: FilledButton.icon(
                          onPressed: state.uInt8 == null
                              ? null
                              : () => openPdfBytesInBrowser(state.uInt8!),
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Buka PDF di tab baru'),
                        ),
                      );
                    }
                    return ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppDimens.radiusLarge),
                      ),
                      child: PDFView(
                        filePath: state.file!.path,
                        enableSwipe: true,
                        swipeHorizontal: true,
                        autoSpacing: false,
                        pageFling: true,
                        pageSnap: true,
                        onError: context.read<GlobalPdfViewerCubit>().hasError,
                        onPageError: (_, e) =>
                            context.read<GlobalPdfViewerCubit>().hasError(e),
                        onLinkHandler: (String? uri) =>
                            AppUtility.launchLink(uri),
                      ),
                    );
                  } else if (state.status.isNotLoaded) {
                    return Center(
                      child: FailureViewWidget(
                        failure: UnknownFailure(message: state.message),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
