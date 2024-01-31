import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tikeri/constants/config.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import '../HomePage.dart';

class LiveStreamBasePage extends StatefulWidget {
  const LiveStreamBasePage({Key? key}) : super(key: key);

  @override
  State<LiveStreamBasePage> createState() => _LiveStreamBasePageState();
}

class _LiveStreamBasePageState extends State<LiveStreamBasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        elevation: 0, // Set elevation to 0 for no shadowkjh
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
    onPressed: () {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => MyHomePage()));
    },
    )),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: (){

                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ZegoLiveStream(
                      uid: '111111', username: "Start", liveID: '123123')));
                },
                child: const Text('Start Live Stream')),
            SizedBox(height: 10,),
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ZegoLiveStream(
                      uid: '121212', username: "Start", liveID: '123123')));
                },
                child: const Text('Join Live Stream')),
          ],
        ),
      ),
    );
  }
}

class ZegoLiveStream extends StatefulWidget {
  final String uid;
  final String username;
  final String liveID;
  const ZegoLiveStream({super.key,
    required this.uid,
    required this.username,
    required this.liveID,
  });

  @override
  State<ZegoLiveStream> createState() => _ZegoLiveStreamState();
}

class _ZegoLiveStreamState extends State<ZegoLiveStream> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
          appID: appId,
          appSign: appSign,
          userID: widget.uid,
          userName: widget.username,
          liveID: widget.liveID,
          config: widget.uid == '111111' ? ZegoUIKitPrebuiltLiveStreamingConfig.host():ZegoUIKitPrebuiltLiveStreamingConfig.audience()),
    );
  }
}
