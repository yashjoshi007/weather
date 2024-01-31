import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {

  final controller;
  final String hintText;
  final bool obsecureText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;


  const MyTextField({
    super.key,
  required this.controller,
  required this.hintText,
  required this.obsecureText,
  required this.validator,
  required this.onSaved, required int maxLines,

});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
          autofocus: false,
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          validator: validator,
          onSaved: onSaved,
          obscureText: obsecureText,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(

            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),

      ),

    );
  }
}

class MyTextField2 extends StatelessWidget {

  final controller;
  final String hintText;
  final bool obsecureText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;


  const MyTextField2({
  super.key,
  required this.controller,
  required this.hintText,
  required this.obsecureText,
  required this.validator,
  required this.onSaved,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(

          autofocus: false,
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          validator: validator,
          onSaved: onSaved,
          obscureText: obsecureText,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(


            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        maxLines: 5, // <-- SEE HERE
        ),
    );
  }
}
