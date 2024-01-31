import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tikeri/screens/loginScreens/signIn_page.dart';

import '../../components/button.dart';
import '../../components/textfield.dart';
import '../../constants/theme.dart';
import '../../main.dart';
import '../HomePage.dart';
import 'forgotpwd_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme().colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: 100,
                          child: Image.network(
                            "https://aneridevelopers.b-cdn.net/wp-content/uploads/2021/03/full-logo.png",
                            fit: BoxFit.contain,
                          )),
                      SizedBox(height: 45),

                      //Email
                      MyTextField(
                        maxLines:1,
                        controller: emailController,
                        hintText: "Email",
                        obsecureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Your Email");
                          }
                          // reg expression for email validation
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please Enter a valid email");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                      ),

                      SizedBox(height: 25),

                      // Password
                      MyTextField(
                        maxLines:1,
                        controller: passwordController,
                        hintText: "Password",
                        obsecureText: true,
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("Password is required for login");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid Password(Min. 6 Character)");
                          }
                        },
                        onSaved: (value) {
                          passwordController.text = value!;
                        },
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      // Forgot Password
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ForgotPassword();
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password ?',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      //Login
                      MyButton(
                          text: ('Login'),
                          onPressed: () {
                            signIn(
                                emailController.text, passwordController.text);
                          }),
                      SizedBox(height: 30),
                      // OR divider
                      Row(children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                        Text(' OR '),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => signinPage()));
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Color(0xFF745E27),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            )
                          ])
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // login function
  Future<void> signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(
              msg: "No user found for that email",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(
              msg: "Wrong password provided for that user",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (e.code == 'invalid-email') {
          Fluttertoast.showToast(
              msg: "Invalid email format",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: e.message!,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Get the Google sign-in account object
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // Get the Google Sign-In authentication object
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      // Create a Firebase credential using the Google Sign-In authentication object
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Get the user details
      final user = userCredential.user;
      final displayName = user?.displayName;
      final email = user?.email;
      final photoUrl = user?.photoURL;

      // Save the user details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
      });

      return userCredential;
    }

    return null;
  }
}
