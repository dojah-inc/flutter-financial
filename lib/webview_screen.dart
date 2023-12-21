import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    hide PermissionStatus;

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
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
    useHybridComposition: true,
    allowsInlineMediaPlayback: true,
    javaScriptEnabled: false,
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
      settings: PullToRefreshSettings(color: Colors.blue),
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
    await initLocationPermissions();
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

  Future initLocationPermissions() async {
    bool serviceEnabled;

    Location location = Location();

    LocationData locationData;

    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      print("Inside _serviceEnabled");

      print(serviceEnabled);
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Inside !_serviceEnabled");

        print(serviceEnabled);

        return true;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      print("Inside Permission denied");

      print(permissionGranted);

      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Inside Permission granted");

        print(permissionGranted);
        setState(() {
          isLocationPermissionGranted = true;
        });
        return true;
      }
    }

    locationData = await location.getLocation();

    final latitude = locationData.latitude;

    final longitude = locationData.longitude;

    DateTime dateTime = DateTime.now();

    final timeZoneName = dateTime.timeZoneName;
    final timeZoneOffset = dateTime.timeZoneOffset;

    locationObject = {
      "lat": latitude,
      "long": longitude,
      "timezone": timeZoneName,
      //"timezoneOffset" : timeZoneOffset,
    };

    if (await Permission.locationWhenInUse.request().isGranted) {
      setState(() {
        isLocationGranted = true;
        locationData = locationData;
        timeZone = timeZoneName;
        zoneOffset = timeZoneOffset;
        locationObject = locationObject;
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
              onGeolocationPermissionsShowPrompt: (controller, origin) async {
                return GeolocationPermissionShowPromptResponse(
                    allow: true, retain: true, origin: origin);
              },
              onPermissionRequest: (controller, origin) async {
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
              onConsoleMessage: (controller, consoleMessage) {},
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
