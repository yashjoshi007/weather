import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/button.dart';
import '../../components/textfield.dart';
import '../../constants/theme.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController email1Controller = new TextEditingController();
  @override
  void dispose(){
    email1Controller.dispose();
    super.dispose();

  }

  Future passwordReset() async{
    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email1Controller.text.trim());
      showDialog(
          context: context,
          builder: (context)
          {
            return AlertDialog(
              content: Text('Password reset link sent! Check your email'),
            );

          });

    }
    on FirebaseException catch(e)
    {
      print(e);
      showDialog(
          context: context,
          builder: (context)
          {
            return AlertDialog(
              content: Text(e.message.toString()),
            );

          });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Reset Password',style: MyTheme().textTheme.headline3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme().primaryColor),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text('Enter your email and we will send you a password reset link',
                textAlign: TextAlign.left,
                style: MyTheme().textTheme.subtitle1,),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100.0,
                      width: 100.0,
                      child: Image.network('https://aneridevelopers.b-cdn.net/wp-content/uploads/2021/03/full-logo.png'),
                    ),
                  ),
                ],
              ),
            ),
            MyTextField(maxLines:1,controller: email1Controller, hintText: "Enter Email", obsecureText: false, validator: (value) {
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
                email1Controller.text = value!;
              }, ),
            SizedBox(height: 30,),
            MyButton(text: "Reset", onPressed: () {

              passwordReset();
            })
          ],
        ),
      ),

    );
  }
}
