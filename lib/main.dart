import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://mch.liveblog365.com'));
    _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (String url) {
          _controller.runJavaScript('''
            // Add viewport meta tag if not present
            if (!document.querySelector('meta[name="viewport"]')) {
              var meta = document.createElement('meta');
              meta.name = "viewport";
              meta.content = "width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no";
              document.head.appendChild(meta);
            }
            // Force body to fit width and prevent horizontal scroll
            document.body.style.overflowX = 'hidden';
            document.body.style.width = '100vw';
            document.documentElement.style.overflowX = 'hidden';
            document.documentElement.style.width = '100vw';
          ''');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCH System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          top: true,
          bottom: false,
          left: false,
          right: false,
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
