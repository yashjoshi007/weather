import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tikeri/screens/loginScreens/login_page.dart';
import 'package:tikeri/screens/ui/homepage.dart';
import 'package:tikeri/screens/ui/weather.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: 'assets/ic_mostly_cloudy.png', // Path to your animated splash screen video
        nextScreen: AuthChecker(), // Navigate to AuthChecker after splash screen
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
    );
  }

  DateTime? _lastBackPressed;

  Future<bool> _onWillPop(BuildContext context) async {
    if (_lastBackPressed == null || DateTime.now().difference(_lastBackPressed!) > Duration(seconds: 2)) {
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
      return false;
    } else {
      return true;
    }
  }
}
