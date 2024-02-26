import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tikeri/main.dart';
import 'package:tikeri/screens/ui/homepage.dart';
import '../../components/button.dart';
import '../../components/textfield.dart';
import '../../constants/theme.dart';
import '../../models/user_model.dart';
import '../ui/weather.dart';
import 'login_page.dart';

class signinPage extends StatefulWidget {
  const signinPage({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<signinPage> {
  final _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final firstNameEditingController = new TextEditingController();
  final userNameEditingController = new TextEditingController();

  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MyTheme().colorScheme.surface,

      body:
      Center(
        child: SingleChildScrollView(
          child: Container(
            color:  MyTheme().scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 60,
                        child: Image.asset(
                          "assets/ic_mostly_cloudy.png",
                          fit: BoxFit.contain,
                        )),
                    SizedBox(height: 35),
                    MyTextField(maxLines:1,controller: firstNameEditingController, hintText: "First name", obsecureText: false,
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{3,}$');
                        if (value!.isEmpty) {
                          return ("First Name cannot be Empty");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid name(Min. 3 Character)");
                        }
                        return null;
                      }, onSaved: (value) {
                        firstNameEditingController.text = value!;
                      },),
                    SizedBox(height: 20,),
                    // Username
                    MyTextField(maxLines:1,controller: userNameEditingController, hintText: "Username", obsecureText: false,
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{3,}$');
                        if (value!.isEmpty) {
                          return ("UserName cannot be Empty");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid name(Min. 3 Character)");
                        }
                        return null;
                      }, onSaved: (value) {
                        firstNameEditingController.text = value!;
                      },),

                    SizedBox(height: 20),
                    //Email
                    MyTextField(maxLines:1,controller: emailEditingController, hintText: "Email", obsecureText: false,
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
                      }, onSaved: (value) {
                        emailEditingController.text = value!;
                      },),
                    SizedBox(height: 20),
                    //Pwd
                    MyTextField(maxLines:1,controller: passwordEditingController, hintText: "Password", obsecureText: true,
                      validator:(value) {
                        RegExp regex = new RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return ("Password is required for login");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password(Min. 6 Character)");
                        }
                      } , onSaved: (value) {
                        passwordEditingController.text = value!;
                      },),
                    SizedBox(height: 20),
                    //Cpwd
                    MyTextField(maxLines:1,controller:confirmPasswordEditingController , hintText: "Confirm Password", obsecureText: true, validator: (value) {
                      if (confirmPasswordEditingController.text !=
                          passwordEditingController.text) {
                        return "Password don't match";
                      }
                      return null;
                    }, onSaved: (value) {
                      confirmPasswordEditingController.text = value!;
                    }, ),
                    SizedBox(height: 20),
                    //SignUp
                    MyButton(text: "Sign Up", onPressed: () {
                      signUp(emailEditingController.text, passwordEditingController.text);
                    }),
                    SizedBox(height: 15),

                    Row(
                        children: [
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

                    SizedBox(height: 30,),

                    ElevatedButton(

                      style: ElevatedButton.styleFrom(
                       // primary: Colors.white,


                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26.0),
                        ),
                      ),

                      onPressed: ()async {
                        final UserCredential? userCredential = await signInWithGoogle();
                        if (userCredential != null) {
                          // Navigate to the next screen
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => MyHomePage()));
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(38, 15, 38,15),
                        child: Row(

                            children: [
                              SizedBox(
                                  height: 20,
                                  child: Image.network(
                                    "https://user-images.githubusercontent.com/1770056/58111071-c2941c80-7bbe-11e9-8cac-1c3202dffb26.png",
                                    fit: BoxFit.contain,
                                  )),

                              SizedBox(width: 10,),

                              Text('Signup using Google',style: MyTheme().textTheme.bodyText1
                                  ?.copyWith(fontSize: 12,fontWeight: FontWeight.w500, color: Colors.black)),
                            ]),
                      ),
                    ),
                    SizedBox(height: 15,),
                    ElevatedButton(

                      style: ElevatedButton.styleFrom(
                       // primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26.0),
                        ),
                      ),

                      onPressed: (){
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => MyHomePage()));
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(38, 15, 38,15),
                        child: Row(
                            children: [
                              SizedBox(
                                  height: 20,
                                  child: Image.network(
                                    "https://i.pinimg.com/originals/65/22/5a/65225ab6d965e5804a632b643e317bf4.jpg",
                                    fit: BoxFit.contain,
                                  )),

                              SizedBox(width: 10,),

                              Text('Signup using Apple',style: MyTheme().textTheme.bodyText1
                                  ?.copyWith(fontSize: 12,fontWeight: FontWeight.w500, color: Colors.black)),
                            ]),
                      ),
                    ),



                    SizedBox(height: 30,),



                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Already have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoginPage()));
                            },
                            child: Text(
                              "Login",
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
    );

  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: emailEditingController.text.trim(), password: passwordEditingController.text.trim())
          .then((value) => {postDetailsToFirestore()})

          .catchError((e) {

      });
    }
  }

  Future<UserCredential?> signInWithGoogle() async {


    // Get the Google sign-in account object
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn
        .signIn();

    if (googleSignInAccount != null) {
      // Get the Google Sign-In authentication object
      final GoogleSignInAuthentication googleAuth = await googleSignInAccount
          .authentication;

      // Create a Firebase credential using the Google Sign-In authentication object
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // Get the user details
      final user = userCredential.user;
      final displayName = user?.displayName;
      final email = user?.email;
      final photoUrl = user?.photoURL;

      // Save the user details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'username': displayName,
        'email': email,
        'imageurl': photoUrl,
        'name': displayName,
      });

      return userCredential;
    }

    return null;
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.userName = userNameEditingController.text;
    userModel.firstName = firstNameEditingController.text;


    await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toMap());


    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => MyHomePage()),
            (route) => false);


  }
}