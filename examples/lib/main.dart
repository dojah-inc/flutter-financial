import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_dojah_kyc/flutter_dojah_kyc.dart';

void main() async {
  runApp(const MyApp());

// await location.requestService();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          //primarySwatch: Colors.blue,
          ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

Map<dynamic, dynamic> envVars = Platform.environment;

class _HomePageState extends State<HomePage> {
// final appId= envVars['appId']; //your application ID
// final publicKey = envVars['publicKey']; //your public key

  final appId = ""; //your application ID
  final publicKey = ""; //your public key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dojah Widget"),
          //backgroundColor: Colors.yellow,
        ),
        body: Center(
            child: Column(children: <Widget>[
          Container(
            child: TextButton(
              child: const Text(
                'Custom Widget',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                // final userData = {
                //   "first_name": "John",
                //   "last_name": "Dooe",
                //   "dob": "199-05-16",
                //   "residence_country": "Nigeria"
                // };

                final configObj = {"widget_id": "64fefb41419cbc00400249ce"};

                final metaData = {
                  "user_id": "81828289191919193882",
                };

                // final govData = {
                //   "bvn": "456789654323",
                //   "nin": "2345675411111",
                //   "dl": "3243546768767453423",
                //   "mobile": "0811234567"
                // };

                DojahKYC? _dojahKYC;

                ///Use your appId and publicKey
                _dojahKYC = DojahKYC(
                  appId: appId,
                  publicKey: publicKey,
                  type: "custom",
                  //userData: userData,
                  metaData: metaData,
                  config: configObj,
                  // govData: govData,
                  // referenceId: referenceId
                );

                print(json.encode(configObj));
                print(json.encode(configObj));
                //print(userData);
                print(configObj);
                _dojahKYC.open(context,
                    onSuccess: (result) => print(result),
                    onClose: (close) => print('Widget Closed'),
                    onError: (error) => print(error));
              },
            ),
          ),
        ])));
  }
}
