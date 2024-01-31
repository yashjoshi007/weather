import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tikeri/screens/chats/zim_chats.dart';
import 'package:tikeri/screens/streamPages/zim_stream.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class MyConnectPage2 extends StatefulWidget {
  @override
  _MyConnectPageState createState() => _MyConnectPageState();
}

class _MyConnectPageState extends State<MyConnectPage2> {
  TextEditingController id1Controller = TextEditingController();
  TextEditingController id2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: id1Controller,
              decoration: InputDecoration(
                labelText: 'Enter User Id',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: id2Controller,
              decoration: InputDecoration(
                labelText: 'Enter Name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                if (id1Controller.text.isNotEmpty &&
                    id2Controller.text.isNotEmpty) {
                  await ZIMKit().connectUser(
                      id: id1Controller.text, name: id2Controller.text);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LiveStreamBasePage(),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "Please fill up all the fields.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Text('Connect'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
