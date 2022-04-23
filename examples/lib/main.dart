import 'package:flutter/material.dart';
import 'package:flutter_dojah_financial/flutter_dojah_financial.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
// import 'package:logger/logger.dart';
void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.blue,
      ),
      home: const HomePage()
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

// void _askCameraPermission() async {
//   if (await Permission.camera.request().isGranted) {
//     var permissionStatus = await Permission.camera.status;
//     print(permissionStatus);
//     // setState(() {});
//   }
// }

// var logger = Logger();

// logger.d("Logger is working!");

  DojahFinancial? _dojahFinancial;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dojah Widget test"),
      ),
      body:  Center(child: Column(children: <Widget>[  
        Container(
              child: TextButton(  
                child: Text('Link Widget', style: TextStyle(fontSize: 20.0),),  
        
        onPressed: () {

           final userData =  {
            "first_name": "Chijioke",
            "last_name": "Nna",
            "dob": "2022-03-12"
           };
          final configObj = {

          "debug": true,
          "mobile": true,
   
          };

          //Use your appId and publicKey
          _dojahFinancial = DojahFinancial(appId: "6194f5f3c423930034a33f16", 
          publicKey: "prod_pk_GB4WvY5xhNx2JlksqBu9Cd0SI", //   
          type: "link",  //'verification', 'identification', 'verification', 'liveness'
          userData: userData,
          config: configObj,
          
          
          );  //Type can be link, identification, verification
          _dojahFinancial!.open(context, onSuccess: (result) => 
          print(result), 
          // ignore: avoid_print
          onError: (error) => print("widget Error" + error));
        }, 
                    ),  


                    
            ),  

             Container(
              child: TextButton(  
                child: Text('Payment Widget', style: TextStyle(fontSize: 20.0),),  
        
        onPressed: () {

          final userData =  {
            "first_name": "Chijioke",
            "last_name": "Nna",
            "dob": "2022-03-12"
           };
          final configObj = {

          "debug": true,
          "mobile": true,

        //   "aml": false,
        //   "review_process": 'Automatic', // Possible values are 'Automatic' and 'Manual'
        //   "pages": [
        //     { "page": 'government-data', "config": { "bvn": true, "nin": false, "dl": false, "mobile": false, "otp": false, "selfie": false } },
        //     { "page": 'government-data', "config": { "bvn": false, "nin": true, "dl": true, "mobile": false, "otp": false, "selfie": false } },
        //     { "page": 'government-data', "config": { "bvn": false, "nin": false, "dl": false, "mobile": true, "otp": true, "selfie": false } },
        //     { "page": 'selfie' },
        //     { "page": 'id', "config": { "passport": false, "dl": true } },
        // ],
      
          };

          //Use your appId and publicKey
          _dojahFinancial = DojahFinancial(appId: "6000604fb87ea60035ef41bb", 
          publicKey: "prod_pk_7jspvKP2FMkjkSZx1qnbgiMWy", //   test_sk_s3cCLitgcxnPU3UQC8vXum7mA
          type: "payment",  //'verification', 'identification', 'verification', 'liveness'
          userData: userData,
          config: configObj,
          // amount: 100,
          
          );  //Type can be link, identification, verification
          _dojahFinancial!.open(context, onSuccess: (result) => 
          print(result), 
          onError: (error) => print(error));
        }, 
         ),
          ),
            
            Container(
              child: TextButton(  
                child: Text('Identification Widget', style: TextStyle(fontSize: 20.0),),  
        
        onPressed: () {

          final userData =  {
            "first_name": "Chijioke",
            "last_name": "Nna",
            "dob": "2022-03-12"
           };
          final configObj = {

          "debug": true,
          "mobile": true,
          "otp": true,
          "selfie": true,
          "aml": false,
          "review_process": 'Automatic', // Possible values are 'Automatic' and 'Manual'
        //   "pages": [
        //     { "page": 'government-data', "config": { "bvn": true, "nin": false, "dl": false, "mobile": false, "otp": false, "selfie": false } },
        //     { "page": 'government-data', "config": { "bvn": false, "nin": true, "dl": true, "mobile": false, "otp": false, "selfie": false } },
        //     { "page": 'government-data', "config": { "bvn": false, "nin": false, "dl": false, "mobile": true, "otp": true, "selfie": false } },
        //     { "page": 'selfie' },
        //     { "page": 'id', "config": { "passport": false, "dl": true },},
        //     { "page": 'user-data', "first_name": 'Chijioke', "last_name": 'Nna', "dob": '2022-03-12',}
          
        // ],
      
          };

          //Use your appId and publicKey
         _dojahFinancial = DojahFinancial(appId: "6194f5f3c423930034a33f16", 
          publicKey: "prod_pk_GB4WvY5xhNx2JlksqBu9Cd0SI", //   test_sk_s3cCLitgcxnPU3UQC8vXum7mA
          type: "identification",  //'verification', 'identification', 'verification', 'liveness'
          userData: userData,
          config: configObj,
          
          );  //Type can be link, identification, verification
          _dojahFinancial!.open(context, onSuccess: (result) => 
          print(result), 
          onError: (error) => print(error));
        }, 
         ),
          ),

          Container(
              child: TextButton(  
                child: Text('Verification Widget', style: TextStyle(fontSize: 20.0),),  
        
        onPressed: () {

          final userData =  {
            "first_name": "Chijioke",
            "last_name": "Nna",
            "dob": "2022-03-12"
           };
          final configObj = {

          "debug": true,
          "mobile": true,
          "otp": true,
          "selfie": true,
        //   "aml": false,
        //   "review_process": 'Automatic', // Possible values are 'Automatic' and 'Manual'
        //   "pages": [
        //     { "page": 'government-data', "config": { "bvn": true, "nin": false, "dl": false, "mobile": false, "otp": false, "selfie": false } },
        //     { "page": 'government-data', "config": { "bvn": false, "nin": true, "dl": true, "mobile": false, "otp": false, "selfie": false } },
        //     { "page": 'government-data', "config": { "bvn": false, "nin": false, "dl": false, "mobile": true, "otp": true, "selfie": false } },
        //     { "page": 'selfie' },
        //     { "page": 'id', "config": { "passport": false, "dl": true } },
        // ],
      
          };

          //Use your appId and publicKey
          _dojahFinancial = DojahFinancial(appId: "6194f5f3c423930034a33f16", 
          publicKey: "prod_pk_GB4WvY5xhNx2JlksqBu9Cd0SI", //   test_sk_s3cCLitgcxnPU3UQC8vXum7mA
          type: "verification",  //'verification', 'identification', 'verification', 'liveness'
          userData: userData,
          config: configObj,
          
          );  //Type can be link, identification, verification
          _dojahFinancial!.open(context, onSuccess: (result) => 
          print(result), 
          onError: (error) => print(error));
        }, 
         ),
          ),
          Container(
              child: TextButton(  
                child: Text('Liveness Widget', style: TextStyle(fontSize: 20.0),),  
        
        onPressed: () {

          final userData =  {
            "first_name": "Chijioke",
            "last_name": "Nna",
            "dob": "2022-03-12"
           };
          final configObj = {

          "debug": true,
          "mobile": true,
        //   "aml": false,
        //   "review_process": 'Automatic', // Possible values are 'Automatic' and 'Manual'
        //   "pages": [
        //     { "page": 'government-data', "config": { "bvn": true, "nin": false, "dl": false, "mobile": false, "otp": false, "selfie": false } },
        //     { "page": 'government-data', "config": { "bvn": false, "nin": true, "dl": true, "mobile": false, "otp": false, "selfie": false } },
        //     { "page": 'government-data', "config": { "bvn": false, "nin": false, "dl": false, "mobile": true, "otp": true, "selfie": false } },
        //     { "page": 'selfie' },
        //     { "page": 'id', "config": { "passport": false, "dl": true } },
        // ],
      
          };

//             var status = await Permission.camera.status;
//             if (status.isDenied) {
//   // We didn't ask for permission yet or the permission has been denied before but not permanently.
// }
          //Use your appId and publicKey
          _dojahFinancial = DojahFinancial(appId: "6194f5f3c423930034a33f16", 
          publicKey: "prod_pk_GB4WvY5xhNx2JlksqBu9Cd0SI", //   test_sk_s3cCLitgcxnPU3UQC8vXum7mA
          type: "liveness",  //'verification', 'identification', 'verification', 'liveness'
          userData: userData,
          config: configObj,
          
          );  //Type can be link, identification, verification
          _dojahFinancial!.open(context, onSuccess: (result) => 
          print(result), 
          onError: (error) => print(error));
        }, 
         ),
          ),
          
          
          
          Container(
              child: TextButton(  
                child: Text('Custom Widget', style: TextStyle(fontSize: 20.0),),  
        
        onPressed: () {

                void _askCameraPermission() async {
                    final requestCam = await Permission.camera.request();

                    print(requestCam);
                      

                    //  final requestMic = await Permission.microphone.request();

                    // print(requestMic);

                                    
                      ///// await openAppSettings();

                 
                      if (await Permission.camera.request().isGranted) {
                      
                        final permissionStatus = await Permission.camera.status;


                        final permissionStatusMic = await Permission.microphone.status;


                        if (permissionStatus == 'undetermined' || permissionStatus == 'denied' || permissionStatus == 'restricted' || permissionStatus == 'permanentlyDenied') {

                        final requestCam = await Permission.camera.request();
                            // await openAppSettings();

                        }

                        //  if (permissionStatusMic == 'undetermined' || permissionStatusMic == 'denied' || permissionStatusMic == 'restricted' || permissionStatusMic == 'permanentlyDenied') {

                        //     await openAppSettings();

                        // }

                     

                        // setState(() {});
                      }

                }
                       print("permissionStatus");
                      _askCameraPermission();
                    


                    
                              final userData = {
                                "first_name": "Chijioke",
                                "last_name": "Nna",
                                "dob": "2022-03-12"
                              };


                              final configObj = {

                                      "debug": true,
                                      "mobile": true,
                                      "otp": true,
                                      "selfie": true,
                                      "aml": false,
                                      "review_process": "Automatic", 
                                      "pages": [
                                        // { "page": "government-data", "config": { "bvn": false, "nin": true, "dl": false, "mobile": false, "otp": false, "selfie": false } },
                                      
                                        { "page": "selfie" },
                                        { "page": "id", "config": { "passport": false, "dl": true }}
                                      
                                      
                                    ]
                            
                              };

                                

                                //Use your appId and publicKey
                              _dojahFinancial = DojahFinancial(appId: "6000604fb87ea60035ef41bb", 
                                publicKey: "prod_pk_7jspvKP2FMkjkSZx1qnbgiMWy", //   test_sk_s3cCLitgcxnPU3UQC8vXum7mA
                                type: "custom",  //'verification', 'identification', 'verification', 'liveness'
                                userData: userData,
                                config: configObj,
                                
                                );  
                                //Type can be link, identification, verification
                          
                              
                                print(json.encode(configObj));
                                print(json.encode(configObj));
                                print(userData);
                                print(configObj);
                                _dojahFinancial!.open(context, onSuccess: (result) => 
                                print(result), 
                                onError: (error) => print(error));
                              },
                                            
                                            

                              // setState(() {});
                                          
  

        
                              
                        
         ),
          ),
           ]  
         ))  
      );  
 
  }  
}     

      








      

  