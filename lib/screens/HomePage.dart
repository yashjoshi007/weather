import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tikeri/screens/communication.dart';
import 'package:tikeri/screens/loginScreens/login_page.dart';
import 'package:tikeri/screens/streaming.dart';
import 'package:tikeri/screens/videosScreens/upload_video.dart';
import 'package:tikeri/screens/videosScreens/videos_screen.dart';
import 'package:tikeri/screens/chats/zimLogin.dart';
import 'package:tikeri/screens/streamPages/zimLoginStream.dart';
import 'package:tikeri/screens/streamPages/zim_stream.dart';

import '../constants/theme.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MyConnectPage(),
    VideoCard(),
    MyConnectPage2(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Set elevation to 0 for no shadow
        backgroundColor: Colors.white, // Set background color
        title: Row(
          children: [
            Image.network(
              'https://aneridevelopers.b-cdn.net/wp-content/uploads/2021/03/full-logo.png', // Replace with the path to your image
              height: 40, // Adjust the height as needed
              width: 40, // Adjust the width as needed
            ),
            SizedBox(width: 15), // Add some spacing between image and title
            Text(
              'TIKERI',
              style: GoogleFonts.robotoFlex(
                fontSize: 20,
                color: Color(0xFFD4A9E5),
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

      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outlined),
            label: 'Teels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business_outlined),
            label: 'Stream',
          ),

        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              (context),
              MaterialPageRoute(builder: (context) => CameraPage()),
                  (route) => false);
        },
        child: Icon(Icons.add),
      )
          : null,
    );
  }
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Page One Content',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Page Two Content',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
