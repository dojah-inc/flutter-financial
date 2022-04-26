import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class WebviewScreen extends StatefulWidget {
  final String appId;
  final String publicKey;
  final String type;
  final int? amount;
  final Map<String, dynamic>? userData;
  final Map<String, dynamic>? config;
  final Function(dynamic) success;
  final Function(dynamic) error;
  const WebviewScreen({
    Key? key,
    required this.appId,
    required this.publicKey,
    required this.type,
    required this.userData,
    required this.config,
    this.amount,
    required this.success,
    required this.error,
  }) : super(key: key);

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  InAppWebViewController? _webViewController;
  
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  bool isGranted = false;

  @override
  void initState() {
    super.initState();

    initPermissions();
  }

  Future initPermissions() async {
    if (await Permission.camera.request().isGranted) {
      setState(() {
        isGranted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dojah Widget"),
        ),

        
        body: isGranted
        
        
        ? InAppWebView(
       
   
          initialData: InAppWebViewInitialData(
            baseUrl:  Uri.parse("https://demo.widget.dojah.io/example.html"),
            androidHistoryUrl :  Uri.parse("https://demo.widget.dojah.io/example.html"),
            mimeType: "text/html",
            data: """
                      <html lang="en">
                        <head>
                            <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, shrink-to-fit=1"/>
                              

                            <title>Dojah Inc.</title>

                        </head>
                        <body>
                  
                        <script src="https://widget.dojah.io/widget.js"></script>
                        <script>
                                  const options = {
                                      app_id: "${widget.appId}",
                                      p_key: "${widget.publicKey}",
                                      type: "${widget.type}",
                                      config: ${json.encode(widget.config ?? {})},
                                      user_data: ${json.encode(widget.userData ?? {})},
                                      amount: ${widget.amount},
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
                  """,
          ),

           initialUrlRequest: URLRequest(
           url: Uri.parse("https://demo.widget.dojah.io/example.html")
       ),

          initialOptions: options,
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

}
