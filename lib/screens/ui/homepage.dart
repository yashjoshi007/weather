import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tikeri/screens/ui/weat_loc.dart';
import 'package:tikeri/utils/repositories/weather_loc_repo.dart';
import '../../utils/blocs/weat_loc_bloc.dart';
import '../loginScreens/login_page.dart';
import 'weather.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  late PageController _pageController;
  List<Widget> _widgetOptions = [
    WeatherPage(),
    BlocProvider(
      create: (context) => WeatherBloc(weatherRepository: WeatherRepositoryLoc()),
      child: WeatherPageLoc(),
    ),

  ];
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // AppLocalization();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signOutGoogle() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _googleSignIn.disconnect();
    await _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Set elevation to 0 for no shadow
        backgroundColor: Colors.white, // Set background color
        title: Row(
          children: [
            Image.asset(
              'assets/ic_storm_weather.png', // Replace with the path to your image
              height: 40, // Adjust the height as needed
              width: 40, // Adjust the width as needed
            ),
            SizedBox(width: 15), // Add some spacing between image and title
            Text(
              'Weather Reports',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Color(0xFF1B101F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async{
              try {
                await FirebaseAuth.instance.signOut();
                await _googleSignIn.signOut();
                await _googleSignIn.disconnect();
                await _googleSignIn.signInSilently();

                // If the sign out is successful, you might want to navigate to the login screen
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
              } catch (e) {
                // Handle sign-out errors
                print("Error signing out: $e");
              }
            },
          ),
        ],
        // Other AppBar properties can be added here
      ),
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        backgroundColor: Colors.grey,
        animationDuration: Duration(milliseconds: 400),
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text(
              'Weather',
              style: GoogleFonts.poppins(),
            ),
            icon: Icon(Icons.ac_unit),
            activeColor: Colors.white,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            title: Text(
              'Location',
              style: GoogleFonts.poppins(),
            ),
            icon: Icon(Icons.search_rounded),
            activeColor: Colors.white,
            inactiveColor: Colors.black,
          ),

        ],
      ),
    );
  }
}
