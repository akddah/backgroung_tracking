// // Copyright 2013 The Flutter Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// // ignore_for_file: public_member_api_docs

// import 'dart:async';

// import 'package:face_id_finger_print/Login/loginVirw.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';

// void main() {
//   runApp(MaterialApp(
//     home: LoginView(),
//     navigatorKey: navigator,
//   ));
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final LocalAuthentication auth = LocalAuthentication();
//   _SupportState _supportState = _SupportState.unknown;
//   bool _canCheckBiometrics;
//   List<BiometricType> _availableBiometrics;
//   String _authorized = 'Not Authorized';
//   bool _isAuthenticating = false;

//   @override
//   void initState() {
//     super.initState();
//     auth.isDeviceSupported().then(
//           (isSupported) => setState(() => _supportState = isSupported
//               ? _SupportState.supported
//               : _SupportState.unsupported),
//         );
//   }

//   Future<void> _checkBiometrics() async {
//     bool canCheckBiometrics;
//     try {
//       canCheckBiometrics = await auth.canCheckBiometrics;
//     } on PlatformException catch (e) {
//       canCheckBiometrics = false;
//       print(e);
//     }
//     if (!mounted) return;

//     setState(() {
//       _canCheckBiometrics = canCheckBiometrics;
//     });
//   }

//   Future<void> _getAvailableBiometrics() async {
//     List<BiometricType> availableBiometrics;
//     try {
//       availableBiometrics = await auth.getAvailableBiometrics();
//     } on PlatformException catch (e) {
//       availableBiometrics = <BiometricType>[];
//       print(e);
//     }
//     if (!mounted) return;

//     setState(() {
//       _availableBiometrics = availableBiometrics;
//     });
//   }

//   Future<void> _authenticate() async {
//     bool authenticated = false;
//     try {
//       setState(() {
//         _isAuthenticating = true;
//         _authorized = 'Authenticating';
//       });
//       authenticated = await auth.authenticate(
//           localizedReason: 'Let OS determine authentication method',
//           useErrorDialogs: true,
//           stickyAuth: true);
//       setState(() {
//         _isAuthenticating = false;
//       });
//     } on PlatformException catch (e) {
//       print(e);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = "Error - ${e.message}";
//       });
//       return;
//     }
//     if (!mounted) return;

//     setState(
//         () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
//   }

//   Future<void> _authenticateWithBiometrics() async {
//     bool authenticated = false;
//     try {
//       setState(() {
//         _isAuthenticating = true;
//         _authorized = 'Authenticating';
//       });
//       authenticated = await auth.authenticate(
//         localizedReason:
//             'Scan your fingerprint (or face or whatever) to authenticate',
//         useErrorDialogs: true,
//         stickyAuth: true,
//         biometricOnly: true,
//       );
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = 'Authenticating';
//       });
//     } on PlatformException catch (e) {
//       print(e);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = "Error - ${e.message}";
//       });
//       return;
//     }
//     if (!mounted) return;

//     final String message = authenticated ? 'Authorized' : 'Not Authorized';
//     setState(() {
//       _authorized = message;
//     });
//   }

//   void _cancelAuthentication() async {
//     await auth.stopAuthentication();
//     setState(() => _isAuthenticating = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: ListView(
//           padding: const EdgeInsets.only(top: 30),
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (_supportState == _SupportState.unknown)
//                   CircularProgressIndicator()
//                 else if (_supportState == _SupportState.supported)
//                   Text("This device is supported")
//                 else
//                   Text("This device is not supported"),
//                 Divider(height: 100),
//                 Text('Can check biometrics: $_canCheckBiometrics\n'),
//                 ElevatedButton(
//                   child: const Text('Check biometrics'),
//                   onPressed: _checkBiometrics,
//                 ),
//                 Divider(height: 100),
//                 Text('Available biometrics: $_availableBiometrics\n'),
//                 ElevatedButton(
//                   child: const Text('Get available biometrics'),
//                   onPressed: _getAvailableBiometrics,
//                 ),
//                 Divider(height: 100),
//                 Text('Current State: $_authorized\n'),
//                 (_isAuthenticating)
//                     ? ElevatedButton(
//                         onPressed: _cancelAuthentication,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text("Cancel Authentication"),
//                             Icon(Icons.cancel),
//                           ],
//                         ),
//                       )
//                     : Column(
//                         children: [
//                           ElevatedButton(
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text('Authenticate'),
//                                 Icon(Icons.perm_device_information),
//                               ],
//                             ),
//                             onPressed: _authenticate,
//                           ),
//                           ElevatedButton(
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(_isAuthenticating
//                                     ? 'Cancel'
//                                     : 'Authenticate: biometrics only'),
//                                 Icon(Icons.fingerprint),
//                               ],
//                             ),
//                             onPressed: _authenticateWithBiometrics,
//                           ),
//                         ],
//                       ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// enum _SupportState {
//   unknown,
//   supported,
//   unsupported,
// }

// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
// import 'package:redux/redux.dart';
// import 'package:flutter_redux/flutter_redux.dart';

// void main() => runApp(new MyApp());

// @immutable
// class AppState {
//   final counter;
//   AppState(this.counter);
// }

// //action
// enum Actions { Increment }

// //pure function
// AppState reducer(AppState prev, action) {
//   if (action == Actions.Increment) {
//     return new AppState(prev.counter + 1);
//   }
//   return prev;
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Flutter Demo',
//       theme: new ThemeData.dark(),
//       debugShowCheckedModeBanner: false,
//       home: new MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   final store = new Store(reducer, initialState: new AppState(0));

//   @override
//   Widget build(BuildContext context) {
//     return new StoreProvider(
//         store: store,
//         child: new Scaffold(
//           appBar: new AppBar(
//             title: new Text("Redux App"),
//           ),
//           body: new Center(
//             child: new Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 new Text(
//                   'You have pushed the button this many times:',
//                 ),
//                 // new StoreConnector(
//                 //   converter: (store) => store.state.counter,
//                 //   builder: (context, counter) => new Text(
//                 //     '$counter',
//                 //     style: Theme.of(context).textTheme.display1,
//                 //   ),
//                 // )
//               ],
//             ),
//           ),
//           floatingActionButton: new StoreConnector(
//             converter: (store) {
//               return () => store.dispatch(Actions.Increment);
//             },
//             builder: (context, callback) => new FloatingActionButton(
//               onPressed: callback,
//               tooltip: 'Increment',
//               child: new Icon(Icons.add),
//             ), // This trailing comma makes auto-formatting nicer for build methods.
//           ),
//         ));
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:face_id_finger_print/helper/location_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

import 'helper/file_manager.dart';
import 'helper/location_callback_handler.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ReceivePort port = ReceivePort();

  String logStr = '';
  bool isRunning;
  LocationDto lastLocation;

  @override
  void initState() {
    super.initState();

    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);

    port.listen(
      (dynamic data) async {
        await updateUI(data);
      },
    );
    initPlatformState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  Future<void> updateUI(LocationDto data) async {
    final log = await FileManager.readLogFile();

    await _updateNotificationText(data);

    setState(() {
      if (data != null) {
        lastLocation = data;
      }
      logStr = log;
    });
  }

  Future<void> _updateNotificationText(LocationDto data) async {
    if (data == null) {
      return;
    }

    await BackgroundLocator.updateNotificationText(
      title: "new location received",
      msg: "${DateTime.now()}",
      bigMsg: "${data.latitude}, ${data.longitude}",
    );
    await sendFcm();
    print(
      "====================>>>>> SEND REQUEST TO BACKEND TO UPDATE LOCATION",
    );
  }

  Future<void> initPlatformState() async {
    print('Initializing...');
    await BackgroundLocator.initialize();
    logStr = await FileManager.readLogFile();
    print('Initialization done');
    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning = _isRunning;
    });
    print('Running ${isRunning.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    final start = SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        child: Text('Start'),
        onPressed: () {
          _onStart();
        },
      ),
    );
    final stop = SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        child: Text('Stop'),
        onPressed: () {
          onStop();
        },
      ),
    );
    final clear = SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        child: Text('Clear Log'),
        onPressed: () {
          FileManager.clearLogFile();
          setState(() {
            logStr = '';
          });
        },
      ),
    );
    String msgStatus = "-";
    if (isRunning != null) {
      if (isRunning) {
        msgStatus = 'Is running';
      } else {
        msgStatus = 'Is not running';
      }
    }
    final status = Text("Status: $msgStatus");

    final log = Text(
      logStr,
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter background Locator'),
        ),
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(22),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[start, stop, clear, status, log],
            ),
          ),
        ),
      ),
    );
  }

  void onStop() async {
    await BackgroundLocator.unRegisterLocationUpdate();
    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning = _isRunning;
    });
  }

  void _onStart() async {
    await _startLocator();
    final _isRunning = await BackgroundLocator.isServiceRunning();

    setState(() {
      isRunning = _isRunning;
      lastLocation = null;
    });
    if (await _checkLocationPermission()) {
      await _startLocator();
      final _isRunning = await BackgroundLocator.isServiceRunning();

      setState(() {
        isRunning = _isRunning;
        lastLocation = null;
      });
    } else {
      // show error
    }
  }

  Future<bool> _checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
    switch (access) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        final permission = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationAlways,
        );
        if (permission == PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }
        break;
      case PermissionStatus.granted:
        return true;
        break;
      default:
        return false;
        break;
    }
  }

  Future<void> _startLocator() async {
    Map<String, dynamic> data = {'countInit': 1};
    await BackgroundLocator.registerLocationUpdate(
      LocationCallbackHandler.callback,
      initCallback: LocationCallbackHandler.initCallback,
      initDataCallback: data,
      disposeCallback: LocationCallbackHandler.disposeCallback,
      iosSettings:
          IOSSettings(accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
      autoStop: false,
      androidSettings: AndroidSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        interval: 5,
        distanceFilter: 0,
        client: LocationClient.google,
        androidNotificationSettings: AndroidNotificationSettings(
          notificationChannelName: 'Location tracking',
          notificationTitle: 'Start Location Tracking',
          notificationMsg: 'Track location in background',
          notificationBigMsg:
              'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
          notificationIconColor: Colors.grey,
          notificationTapCallback: LocationCallbackHandler.notificationCallback,
        ),
      ),
    );
  }
}

sendFcm() async {
  await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAA2kfMzks:APA91bGBOfJBueofA5pGZ_EIJwA01fZ5ZhsVEpdf3g-PdXVDWErobwKtqKvYnlkgffzZ_IXubjleWCQcNImMDf_OzUZbKaWcGyiDXm1O4Pa76Smcp1Xs0sgEFQAziBVvbj7AAKv5XQJC',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{'body': "test", 'title': "test"},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to':
            "f_gFQhm8QxSLdazHnRVLFL:APA91bECGqasNdjbqjiRDylxU_mW5hoDOv_EoKD5Fu8cVDkIwoZnRUFqXo5IAm7YNANNEMMsxXrj0riYp8VI5fc-4KpIwQ63pYrm-d5cn2w07DFvn-zJojQePhq3sUmYb_yLHW_h2BXz",
      },
    ),
  );
}
