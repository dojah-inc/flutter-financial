import 'dart:convert';

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
        pages!.add(Pages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['debug'] = debug;
    data['mobile'] = mobile;
    data['otp'] = otp;
    data['selfie'] = selfie;
    data['aml'] = aml;
    data['review_process'] = reviewProcess;
    if (pages != null) {
      data['pages'] = pages!.map((v) => v.toJson()).toList();
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
    config = json['config'] != null ? Config.fromJson(json['config']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    if (config != null) {
      data['config'] = config!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bvn'] = bvn;
    data['nin'] = nin;
    data['dl'] = dl;
    data['mobile'] = mobile;
    data['otp'] = otp;
    data['selfie'] = selfie;
    return data;
  }
}

class _WebviewScreenState extends State<WebviewScreen> {
  InAppWebViewController? _webViewController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
        clearCache: true,
        javaScriptEnabled: true,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      geolocationEnabled: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: false,
    ),
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
    //initiateGeoLocation();
  }

  // Future<bool> initiateGeoLocation() async {
  //   log("it works");
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  //   if (!serviceEnabled) {
  //     print('Location services are disabled.');
  //     return false;
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();

  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     print('Location permissions are denied main.');
  //     return false;
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     print(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //     return false;
  //   }

  //   Geolocator.getPositionStream().listen((Position position) {
  //     // Update the location icon in the webview widget.
  //     // ...

  //     print('Listen to Current main Location: $permission');
  //   });

  //   setState(() {
  //     isLocationGranted = true;
  //   });

  //   log(permission.name);
  //   return true;
  // }

  Future getPermissions() async {
    await initLocationPermissions();

    await initPermissions();
  }

  Future initPermissions() async {
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

    PermissionStatus _permissionGranted;

    print("Before Permissions");

    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      print("Inside _serviceEnabled");

      print(_serviceEnabled);
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print("Inside !_serviceEnabled");

        print(_serviceEnabled);

        return true;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      print("Inside Permission denied");

      print(_permissionGranted);

      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("Inside Permission granted");

        print(_permissionGranted);
        setState(() {
          isLocationPermissionGranted = true;
        });
        return true;
      }
    }

    _locationData = await location.getLocation();

    print("Location Data");

    print(_locationData);

    final latitude = _locationData.latitude;

    final longitude = _locationData.longitude;

    print("longitude");
    print(longitude);

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

    print("Permissions");
    print(_permissionGranted);

    print("Location Object");

    print(json.encode(_locationObject));

    if (_permissionGranted == PermissionStatus.granted) {
      print("Permission granted!");
      setState(() {
        isGranted = true;
      });
    }

    if (await Permission.locationWhenInUse.request().isGranted) {
      print("locationWhenInUse enebaled!");
      setState(() {
        isGranted = true;
        isLocationGranted = true;
        locationData = _locationData;
        timeZone = timeZoneName;
        zoneOffset = timeZoneOffset;
        locationObject = _locationObject;
      });

      //await location.enableBackgroundMode(enable: true);
    }
  }
  // returns an object with the following keys - latitude, longitude, and timezone

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: const Text("Dojah Widget"),
          //backgroundColor: Colors.yellow,
          ),
      body: isGranted
          ? InAppWebView(
              initialData: InAppWebViewInitialData(
                baseUrl: WebUri.uri(Uri.parse("https://widget.dojah.io")),
                // baseUrl: Uri.parse("https://widget.dojah.io"),
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
                url: WebUri.uri(Uri.parse("https://widget.dojah.io")),
              ),
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
                    // if (response.first == 'close') {
                    //   Navigator.pop(context);
                    // }
                  },
                );

                _webViewController?.addJavaScriptHandler(
                  handlerName: 'onErrorCallback',
                  callback: (error) {
                    widget.error(error);
                  },
                );
              },
              androidOnGeolocationPermissionsShowPrompt:
                  (controller, origin) async {
                return GeolocationPermissionShowPromptResponse(
                    allow: true, retain: true, origin: origin);
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
