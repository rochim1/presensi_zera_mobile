import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' show markdownToHtml;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

@RoutePage()
class EmailDetailPage extends StatelessWidget {
  final EmailEntity email;
  final bool embedded;

  const EmailDetailPage({
    super.key,
    required this.email,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    DateTime? parsedDate;
    if (email.createdAt != null) {
      final timestamp = int.tryParse(email.createdAt!);
      if (timestamp != null) {
        parsedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else {
        parsedDate = DateTime.tryParse(email.createdAt!);
      }
    }
    final timeStr = parsedDate != null
        ? DateFormat('dd MMMM yyyy, HH:mm').format(parsedDate.toLocal())
        : '';
    final sender = email.senderId?.name ?? 'Sistem';

    return Scaffold(
      appBar: embedded
          ? null
          : const AppTopBar(
              title: 'Detail Pesan Internal',
              backgroundColor: AppColors.white,
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(AppDimens.paddingMediumX),
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email.title ?? 'No Subject',
                  style: context.textStyle.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.labelPrimary,
                  ),
                ),
                AppDimens.paddingMediumX.hSpace,
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      backgroundImage:
                          (email.senderId?.urlFoto ?? '').isNotEmpty
                          ? NetworkImage(email.senderId!.urlFoto!)
                          : null,
                      child: (email.senderId?.urlFoto ?? '').isEmpty
                          ? Text(
                              sender.isNotEmpty ? sender[0].toUpperCase() : '?',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sender,
                            style: context.textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            timeStr,
                            style: context.textStyle.bodySmall?.copyWith(
                              color: AppColors.labelSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: Builder(
              builder: (context) {
                final String parsedBody = markdownToHtml(email.body ?? '');

                final String htmlContent =
                    '''
                <!DOCTYPE html>
                <html>
                <head>
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <style>
                    body {
                      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                      padding: 16px;
                      line-height: 1.5;
                      color: #333333;
                    }
                    img {
                      max-width: 100%;
                      height: auto;
                    }
                    p {
                      margin-top: 0;
                      margin-bottom: 1em;
                    }
                  </style>
                </head>
                <body>
                  $parsedBody
                </body>
                </html>
                ''';

                final base64Content = base64Encode(
                  const Utf8Encoder().convert(htmlContent),
                );

                return InAppWebView(
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: false,
                    verticalScrollBarEnabled: true,
                    useShouldOverrideUrlLoading: true,
                    transparentBackground: true,
                  ),
                  initialUrlRequest: URLRequest(
                    url: WebUri('data:text/html;base64,$base64Content'),
                  ),
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                        return NavigationActionPolicy.CANCEL;
                      },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
