import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PdfUrlViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const PdfUrlViewerScreen({
    super.key,
    required this.pdfUrl,
    this.title = 'Document',
  });

  @override
  State<PdfUrlViewerScreen> createState() => _PdfUrlViewerScreenState();
}

class _PdfUrlViewerScreenState extends State<PdfUrlViewerScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final encodedPdfUrl = Uri.encodeComponent(widget.pdfUrl);
    final googleViewerUrl =
        'https://docs.google.com/gview?embedded=true&url=$encodedPdfUrl';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
          onWebResourceError: (_) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(googleViewerUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
