import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.controller, super.key}); // MODIFY

  final  WebViewController controller;                        // ADD

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;
  // REMOVE the controller that was here
  late int counter=0;

  @override
  void initState() {
    super.initState();
    // Modify from here...
    widget.controller.setNavigationDelegate(

      NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
            widget.controller.canGoForward();
          },
          onWebResourceError: (error) {
            print('Web Resource Error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            final host = Uri.parse(request.url).host;
            if(request.url.startsWith('https://zoom.us/signin')) {
              debugPrint('allowing navigation to ${request.url}');
              return NavigationDecision.navigate;
            }
            else if (request.url.startsWith('https://applications.zoom.us/sdkhelper')) {
              debugPrint('blocking navigation to ${request.url}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Blocking navigation to $host',
                  ),
                ),
              );
              Navigator.pop(context);
              // widget.controller.goForward();
              // NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change){
            debugPrint('url change to ${change.url}');
            counter++;
            print(counter);
          }
      ),
    );
    // ...to here.
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: widget.controller,

        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
            minHeight: 10,
            color: Colors.blueAccent,
          ),
      ],
    );
  }
}