import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 通用网页查看器页面
class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key, required this.url, required this.title});

  final String url;
  final String title;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // 可以在这里更新加载进度
          },
          onPageStarted: (String url) {
            // 页面开始加载
          },
          onPageFinished: (String url) {
            // 页面加载完成
          },
          onWebResourceError: (WebResourceError error) {
            // 处理加载错误
            debugPrint('WebView error: ${error.description}');
          },
        ),
      );
    _controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
