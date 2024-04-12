import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class DojahKYC {
  final String appId;
  final String publicKey;
  final String type;
  final int? amount;
  final String? referenceId;
  final Map<String, dynamic>? userData;
  final Map<String, dynamic>? metaData;
  final Map<String, dynamic>? govData;
  final Map<String, dynamic>? config;
  final Function(dynamic)? onCloseCallback;

  DojahKYC({
    required this.appId,
    required this.publicKey,
    required this.type,
    this.userData,
    this.config,
    this.metaData,
    this.govData,
    this.amount,
    this.referenceId,
    this.onCloseCallback,
  });

  Future<void> open(BuildContext context,
      {Function(dynamic result)? onSuccess,
      Function(dynamic close)? onClose,
      Function(dynamic error)? onError}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebviewScreen(
          appId: appId,
          publicKey: publicKey,
          type: type,
          userData: userData,
          metaData: metaData,
          govData: govData,
          config: config,
          amount: amount,
          referenceId: referenceId,
          success: (result) {
            onSuccess!(result);
          },
          close: (close) {
            onClose!(close);
          },
          error: (error) {
            onError!(error);
          },
        ),
      ),
    );
  }
}

class WebviewScreen extends StatefulWidget {
  final String appId;
  final String publicKey;
  final String type;
  final int? amount;
  final String? referenceId;
  final Map<String, dynamic>? userData;
  final Map<String, dynamic>? metaData;
  final Map<String, dynamic>? govData;
  final Map<String, dynamic>? config;
  final Function(dynamic) success;
  final Function(dynamic) error;
  final Function(dynamic) close;
  const WebviewScreen({
    Key? key,
    required this.appId,
    required this.publicKey,
    required this.type,
    this.userData,
    this.metaData,
    this.govData,
    this.config,
    this.amount,
    this.referenceId,
    required this.success,
    required this.error,
    required this.close,
  }) : super(key: key);

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  final GlobalKey webViewKey = GlobalKey();
  late InAppWebViewController _webViewController;
  double progress = 0;
  String url = '';
  late PullToRefreshController pullToRefreshController;

  InAppWebViewSettings options = InAppWebViewSettings(
    allowsInlineMediaPlayback: true,
  );

  bool isGranted = false;
  bool isLocationGranted = false;

  bool isLocationPermissionGranted = false;
  dynamic locationData;
  dynamic timeZone;
  dynamic zoneOffset;
  dynamic locationObject;

  @override
  void initState() {
    super.initState();
    getPermissions();
    pullToRefreshController = PullToRefreshController(
      //settings: PullToRefreshSettings(color: Colors.blue),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _webViewController.reload();
        } else if (Platform.isIOS) {
          _webViewController.loadUrl(
            urlRequest: URLRequest(url: await _webViewController.getUrl()),
          );
        }
      },
    );
  }

  Future getPermissions() async {
    await initPermissions();
  }

  Future initPermissions() async {
    await Permission.camera.request().then((value) {
      if (value.isPermanentlyDenied) {
        openAppSettings();
      }
    });
    if (await Permission.camera.request().isGranted) {
      setState(() {
        isGranted = true;
      });
    } else {
      Permission.camera.onDeniedCallback(() {
        Permission.camera.request();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isGranted
          ? InAppWebView(
              key: webViewKey,
              initialSettings: options,
              initialData: InAppWebViewInitialData(
                baseUrl: WebUri("https://widget.dojah.io"),
                historyUrl: WebUri("https://widget.dojah.io"),
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
                                      gov_data: ${json.encode(widget.govData ?? {})},
                                      location: ${json.encode(locationObject ?? {})},
                                      metadata: ${json.encode(widget.metaData ?? {})},
                                      amount: ${widget.amount},
                                      reference_id: ${widget.referenceId},
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
                url: WebUri("https://widget.dojah.io"),
              ),
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                _webViewController = controller;

                _webViewController.addJavaScriptHandler(
                  handlerName: 'onSuccessCallback',
                  callback: (response) {
                    widget.success(response);
                  },
                );

                _webViewController.addJavaScriptHandler(
                  handlerName: 'onCloseCallback',
                  callback: (response) {
                    widget.close(response);
                    // if (response.first == 'close') {
                    //   Navigator.pop(context);
                    // }
                  },
                );

                _webViewController.addJavaScriptHandler(
                  handlerName: 'onErrorCallback',
                  callback: (error) {
                    widget.error(error);
                  },
                );
              },
              onPermissionRequest: Platform.isAndroid
                  ? null
                  : (controller, origin) async {
                      return PermissionResponse(
                        resources: [],
                        action: PermissionResponseAction.GRANT,
                      );
                    },
              onLoadStop: (controller, url) {
                pullToRefreshController.endRefreshing();
              },
              onReceivedError: (controller, url, code) {
                pullToRefreshController.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                });
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
               androidOnGeolocationPermissionsShowPrompt:
                  (controller, origin) async {
                return GeolocationPermissionShowPromptResponse(
                    allow: true, origin: origin, retain: true);
              },
              onConsoleMessage: (controller, consoleMessage) {},
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}