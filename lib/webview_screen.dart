import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert';
class WebviewScreen extends StatefulWidget {
  final String appId;
  final String publicKey;
  final String type;
   final Map<String, dynamic> userData;
  final Map<String, dynamic> config;
  final Function(dynamic) success;
  final Function(dynamic) error;
  const WebviewScreen({
    Key? key,
    required this.appId,
    required this.publicKey,
    required this.type,
    required this.userData,
    required this.config,
    // required this.amount,
    required this.success,
    required this.error,
  }) : super(key: key);

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dojah Widget"),
      ),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(data: """
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta
 name="viewport"
 content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, shrink-to-fit=1"
/>
    <title>Dojah Inc.</title>
</head>
<body>
<script src="https://widget.dojah.io/widget.js"></script>
<script>
          const options = {
              app_id: "${widget.appId}",
              p_key: "${widget.publicKey}",
              type: "${widget.type}",
              user_data: ${json.encode(widget.userData)},
              config: ${json.encode(widget.config)},
             
         
              onSuccess: function (response) {
               window.flutter_inappwebview.callHandler('onSuccessCallback', response)
              },
              onError: function (err) {
                window.flutter_inappwebview.callHandler('onErrorCallback', error)
              },
              onClose: function () {
                window.flutter_inappwebview.callHandler('onCloseCallback', 'close')
              }
          }
            const connect = new Connect(options);
            connect.setup();
            connect.open();
      </script>
</body>
</html>
                  """),
        initialOptions:
            InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions()),
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;

          _webViewController?.addJavaScriptHandler(
              handlerName: 'onSuccessCallback',
              callback: (response) {
                widget.success(response);
              });

          _webViewController?.addJavaScriptHandler(
              handlerName: 'onCloseCallback',
              callback: (response) {
                // widget.onCloseCallback!(response);
                if (response.first == 'close') {
                  Navigator.pop(context);
                }
              });

          _webViewController?.addJavaScriptHandler(
              handlerName: 'onErrorCallback',
              callback: (error) {
                widget.error(error);
              });
        },
        onConsoleMessage: (controller, consoleMessage) {
          print(consoleMessage.message);
        },
      ),
    );
  }
}
