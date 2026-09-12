import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';

import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';

@RoutePage()
class InAppBrowserPage extends StatefulWidget {
  final String url;

  const InAppBrowserPage({super.key, required this.url});

  @override
  State<InAppBrowserPage> createState() => _InAppBrowserPageState();
}

class _InAppBrowserPageState extends State<InAppBrowserPage> {
  InAppWebViewController? _webViewController;
  double _progress = 0;
  String _pageTitle = "Browser";
  String _currentUrl = "";

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(widget.url);
    final isMobileSurveySession =
        uri?.path.startsWith('/mobile/survey/') ?? false;
    final sessionToken = context.read<AppCubit>().state.session.data?.token;
    final surveyToken = (sessionToken?.isNotEmpty ?? false)
        ? sessionToken
        : fl.token;
    final requestHeaders =
        isMobileSurveySession && (surveyToken?.isNotEmpty ?? false)
        ? <String, String>{'Authorization': 'Bearer $surveyToken'}
        : null;

    return Scaffold(
      appBar: AppBarWidget(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _pageTitle,
              style: context.textTheme.titleMedium?.copyWith(
                fontSize: 16,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _currentUrl,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: AppColors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          Center(
            child: AppTopBarActionButton(
              icon: Icons.refresh,
              onTap: () {
                _webViewController?.reload();
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          if (_progress < 1.0)
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.secondary.withValues(alpha: 0.8),
              ),
            ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri.uri(Uri.parse(widget.url)),
                headers: requestHeaders,
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  _currentUrl = _redactedUrl(url?.toString() ?? widget.url);
                });
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  _currentUrl = _redactedUrl(url?.toString() ?? widget.url);
                });

                final title = await controller.getTitle();
                setState(() {
                  _pageTitle = title ?? "Browser";
                });
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                verticalScrollBarEnabled: true,
                useHybridComposition: true,
                allowsInlineMediaPlayback: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _redactedUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.queryParameters.containsKey('token')) return url;
    return uri
        .replace(queryParameters: {...uri.queryParameters, 'token': '***'})
        .toString();
  }
}
