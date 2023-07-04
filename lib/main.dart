import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zoom_sdk_webview/web_view_stack.dart';

import 'navigation_controls.dart'; // ADD

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  await Permission.microphone.request();
  runApp(

    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  // Add from here...
  late final WebViewController controller;
  PlatformWebViewControllerCreationParams params =
      const PlatformWebViewControllerCreationParams();

  @override
  void initState() {
    super.initState();
    controller =WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: (WebViewPermissionRequest request) {
        request.grant();
      },
    )..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(
        Uri.parse(
            'https://zoom-sdk-sigma.vercel.app/meeting?id=5036513342&pwd=12345&user=test&jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZGtLZXkiOiIwcUpQMWl2MVNDMGFXNmJTTWF4dyIsIm1uIjoiNTAzNjUxMzM0MiIsInJvbGUiOjAsImlhdCI6MTY4ODQ1NDk2NywiZXhwIjoxNjg4NDYyMTY3LCJhcHBLZXkiOiIwcUpQMWl2MVNDMGFXNmJTTWF4dyIsInRva2VuRXhwIjoxNjg4NDYyMTY3fQ.0aqLqZSZn7WfT1KujodU3oIAT9S1t40CdqoK5oYtZrE'),
        method: LoadRequestMethod.get,
      );
  }
  // ...to here.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView'),
        // Add from here...
        actions: [
          NavigationControls(controller: controller),
        ],
        // ...to here.
      ),
      body: WebViewStack(controller: controller), // MODIFY
    );
  }
}
