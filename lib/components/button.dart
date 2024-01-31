
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/theme.dart';
class MyButton extends StatelessWidget {


  final String text;
  final VoidCallback onPressed;


  const MyButton({super.key,required this.text, required this.onPressed}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(26),
          color: MyTheme().colorScheme.primary,
          child: MaterialButton(
              padding: EdgeInsets.fromLTRB(28, 14, 28, 14),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: onPressed ,
              child: Text(text,style: MyTheme().textTheme.bodyText1
                                      ?.copyWith(fontWeight: FontWeight.w500, color: MyTheme().colorScheme.onPrimary)),
          ),
        )
    );
  }
}




class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String header;
  final String description;
  final double height;
  final VoidCallback? onTap;

  const CustomListTile({
    Key? key,
    required this.icon,
    required this.header,
    required this.description,
    this.height = 80.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            ListTile(
              leading: Icon(icon, size: 28.0),
              title: Text(header, style: TextStyle(fontSize: 16.0)),
              subtitle: Text(description, style: TextStyle(fontSize: 10.0)),
            ),

          ],
        ),
      ),
    );
  }
}
