import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart'
    hide PermissionStatus;
import 'package:location/location.dart';

class WebviewScreen extends StatefulWidget {
  final String appId;
  final String publicKey;
  final String type;
  final int? amount;
  final String? referenceId;
  final Map<String, dynamic>? userData;
  final Map<String, dynamic>? metaData;
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

class Configuration {
  bool? debug;
  bool? mobile;
  bool? otp;
  bool? selfie;
  bool? aml;
  String? reviewProcess;
  List<Pages>? pages;

  Configuration(
      {this.debug,
      this.mobile,
      this.otp,
      this.selfie,
      this.aml,
      this.reviewProcess,
      this.pages});

  Configuration.fromJson(Map<String, dynamic> json) {
    debug = json['debug'];
    mobile = json['mobile'];
    otp = json['otp'];
    selfie = json['selfie'];
    aml = json['aml'];
    reviewProcess = json['review_process'];
    if (json['pages'] != null) {
      pages = <Pages>[];
      json['pages'].forEach((v) {
        pages!.add(new Pages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['debug'] = this.debug;
    data['mobile'] = this.mobile;
    data['otp'] = this.otp;
    data['selfie'] = this.selfie;
    data['aml'] = this.aml;
    data['review_process'] = this.reviewProcess;
    if (this.pages != null) {
      data['pages'] = this.pages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pages {
  String? page;
  Config? config;

  Pages({this.page, this.config});

  Pages.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    config =
        json['config'] != null ? new Config.fromJson(json['config']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    if (this.config != null) {
      data['config'] = this.config!.toJson();
    }
    return data;
  }
}

class Config {
  bool? bvn;
  bool? nin;
  bool? dl;
  bool? mobile;
  bool? otp;
  bool? selfie;


  Config({this.bvn, this.nin, this.dl, this.mobile, this.otp, this.selfie});

  Config.fromJson(Map<String, dynamic> json) {
    bvn = json['bvn'];
    nin = json['nin'];
    dl = json['dl'];
    mobile = json['mobile'];
    otp = json['otp'];
    selfie = json['selfie'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bvn'] = this.bvn;
    data['nin'] = this.nin;
    data['dl'] = this.dl;
    data['mobile'] = this.mobile;
    data['otp'] = this.otp;
    data['selfie'] = this.selfie;
    return data;
  }
}

class _WebviewScreenState extends State<WebviewScreen> {
  InAppWebViewController? _webViewController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
        clearCache: true,
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
  bool isLocationGranted = false;
  dynamic locationData;
  dynamic timeZone;
  dynamic zoneOffset;
  dynamic locationObject;

  @override
  void initState() {
    super.initState();

    initCameraPermissions();
    
  }

  Future initCameraPermissions() async {
    await Permission.locationWhenInUse.request();
    if (await Permission.camera.request().isGranted) {
      setState(() {
        isGranted = true;
      });
    }
  }

  Future initLocationPermissions() async {
    bool _serviceEnabled;

    Location location = Location();

    LocationData _locationData;


    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // if (_permissionGranted == PermissionStatus.denied) {
    //   _permissionGranted = await location.requestPermission();
    //   if (_permissionGranted != PermissionStatus.granted) {
    //     return;
    //   }
    // }

    _locationData = await location.getLocation();

    final latitude = _locationData.latitude;

    final longitude = _locationData.longitude;

    DateTime dateTime = DateTime.now();

    final timeZoneName = dateTime.timeZoneName;
    final timeZoneOffset = dateTime.timeZoneOffset;

    final _locationObject = {
      "lat": latitude,
      "long": longitude,
      "timezone": timeZoneName,
      //"timezoneOffset" : timeZoneOffset,
    };

    // print("After Location data");
    // print(dateTime.timeZoneName);

    // print(latitude);
    // print(longitude);
    // print(dateTime.timeZoneOffset);

    //  print(_locationData);

    // print(json.encode(locationObject));

    if (await Permission.locationWhenInUse.request().isGranted) {
      setState(() {
        isLocationGranted = true;
        locationData = _locationData;
        timeZone = timeZoneName;
        zoneOffset = timeZoneOffset;
        locationObject = _locationObject;
      });
    }
  }
  // returns an object with the following keys - latitude, longitude, and timezone

  @override
  Widget build(BuildContext context) {
    // if (widget.type == "custom" ||
    //     widget.type == "verification" ||
    //     widget.type == "liveness" ||
    //     widget.type == "identification") {
    //   initCameraPermissions();
    // }

    dynamic newConfig = widget.config;

    var config = Configuration.fromJson(newConfig);

    var needsCamera = config.selfie;

    if (needsCamera == true) {

     initCameraPermissions();      
     
    }

    var needsLocation =
        config.pages!.where((e) => e.page!.toLowerCase() == "address").toList();

    // final needsLocation = pages.containsValue("address");

    if (needsLocation.isNotEmpty) {
      initLocationPermissions();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dojah Widget"),
      ),
      body: isGranted
          ? InAppWebView(
              initialData: InAppWebViewInitialData(
                baseUrl: Uri.parse("https://widget.dojah.io"),
                androidHistoryUrl: Uri.parse("https://widget.dojah.io"),
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
                                      metadata: ${json.encode(widget.metaData ?? {})},
                                      __location: ${json.encode(locationObject ?? {})},
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
              initialUrlRequest:
                  URLRequest(url: Uri.parse("https://widget.dojah.io")),
              initialOptions: options,
              onWebViewCreated: (controller) {
                _webViewController = controller;

                _webViewController?.addJavaScriptHandler(
                  handlerName: 'onSuccessCallback',
                  callback: (response) {
                    widget.success(response);
                  },
                );

                _webViewController?.addJavaScriptHandler(
                  handlerName: 'onCloseCallback',
                  callback: (response) {
                    widget.close(response);
                    if (response.first == 'close') {
                      Navigator.pop(context);
                    }
                  },
                );

                _webViewController?.addJavaScriptHandler(
                  handlerName: 'onErrorCallback',
                  callback: (error) {
                    widget.error(error);
                  },
                );
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


