<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Installation

First, add flutter_dojah_financial as a dependency in your `pubspec.yaml` file.

### iOS
Add the following keys to your Info.plist file, located in `<project root>/ios/Runner/Info.plist`:

- `NSCameraUsageDescription` - describe why your app needs access to the camera. This is called Privacy - Camera Usage Description in the visual editor.

- `NSMicrophoneUsageDescription` - describe why your app needs access to the microphone, if you intend to record videos. This is called Privacy - Microphone Usage Description in the visual editor.

### Android
```
// Add the camera permission: 
<uses-permission android:name="android.permission.CAMERA" />
// Add the modify audio settings permission:
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
```


## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
final Map<String,dynamic> config = {
  debug: true,
  otp: true, //for verification type
  selfie: true //for verification type
};
 final DojahFinancial _dojahFinancial = DojahFinancial(
    appId: 'xxxxxxxxxxxxxxx',
    publicKey: 'prod_pk_xxxxxxxxxxxxxx',
    type : 'liveness'  //link, identification, verification, payment
    config: config
  );

  _dojahFinancial.open(context, onSuccess: (result) {
    print('$result');
  }, onError: (err) {
    print('error: $err');
  });
```


## Deployment 

`REMEMBER TO CHANGE THE APP ID and PUBLIC KEY WHEN DEPLOYING TO A LIVE (PRODUCTION) ENVIRONMENT`


## Contriburing

- Fork it!
- Create your feature branch: `git checkout -b feature/feature-name`
- Commit your changes: `git commit -am 'Some commit message'`
- Push to the branch: `git push origin feature/feature-name`
- Submit a pull request 😉😉



## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
