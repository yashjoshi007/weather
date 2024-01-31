import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tikeri/screens/HomePage.dart';
import 'package:tikeri/screens/chats/zim_ac.dart';
import 'package:tikeri/screens/chats/zim_vc.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ZimChatsList extends StatelessWidget {
  const ZimChatsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Conversations'),
          backgroundColor: Colors.lightBlue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage()));
            },
          ),
          actions: const [],
        ),
        floatingActionButton:
        FloatingActionButton(
          onPressed: (){
          ZIMKit().showDefaultNewPeerChatDialog(context);
        }, child: Icon(Icons.add  ),),
        body: ZIMKitConversationListView(
          onPressed: (context, conversation, defaultAction) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ZIMKitMessageListPage(
                  conversationID: conversation.id,
                  conversationType: conversation.type,
                  appBarActions: [
                    IconButton(onPressed: (){
                       String id = "111111";
                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => ZimVideoCall(callid: id, userid: conversation.id)));
                    }, icon: Icon(Icons.videocam)),
                    IconButton(onPressed: (){
                      String id = "111111";
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ZimAudioCall(callid: id, userid: conversation.id)));
                    }, icon: Icon(Icons.call))
                  ],
                
                );
              },
            ));
          },
        ),
      ),
    );
  }
}