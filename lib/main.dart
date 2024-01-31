import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tikeri/screens/HomePage.dart';
import 'package:tikeri/screens/loginScreens/login_page.dart';
import 'package:tikeri/screens/chats/zimLogin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'constants/config.dart';

Future<void> main() async {
  await ZIMKit().init(appID: appId, appSign: appSign);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return WillPopScope(
              onWillPop: () async {
                return _onWillPop(context);
              },
              child: MyHomePage(),
            );
          } else {
            return WillPopScope(
              onWillPop: () async {
                return _onWillPop(context);
              },
              child: LoginPage(),
            );
          }
        },
      ),
    );
  }

  DateTime? _lastBackPressed;

  Future<bool> _onWillPop(BuildContext context) async {
    if (_lastBackPressed == null || DateTime.now().difference(_lastBackPressed!) > Duration(seconds: 2)) {
      // Show a toast indicating that the user needs to press back again to exit
      Fluttertoast.showToast(
        msg: "Press back again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      _lastBackPressed = DateTime.now();
      return false; // Prevent the app from exiting
    } else {
      return true; // Allow the app to exit
    }
  }
}
