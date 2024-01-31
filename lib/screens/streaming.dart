import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtcView;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LiveStreamingPage extends StatefulWidget {
  @override
  _LiveStreamingPageState createState() => _LiveStreamingPageState();
}

class _LiveStreamingPageState extends State<LiveStreamingPage> {
  late RtcEngine _rtcEngine;
  bool _isLiveStreaming = false;
  String? _currentUserUid;
  String? _broadcastChannel;

  @override
  void initState() {
    super.initState();
    initializeAgora();
    getUserDetails();
  }

  Future<void> initializeAgora() async {
    // Replace with your Agora App ID
    const agoraAppId = 'e444e6ec14e14f65a89d08afca60be9d';

    // Initialize the Agora RTC Engine
    _rtcEngine = await RtcEngine.create(agoraAppId);
    await _rtcEngine.enableVideo();
    await _rtcEngine.startPreview();
  }

  Future<void> getUserDetails() async {
    // Get current user details from Firebase
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      setState(() {
        _currentUserUid = currentUser.uid;
      });
    }
  }

  Future<void> startLiveStreaming() async {
    // Generate a unique channel name for the live stream
    _broadcastChannel = 'broadcast_${DateTime.now().millisecondsSinceEpoch}';

    // Join the Agora channel for live streaming
    await _rtcEngine.joinChannel(null, _broadcastChannel!, null, 0);

    // Set the live streaming state to true
    setState(() {
      _isLiveStreaming = true;
    });
  }

  Future<void> stopLiveStreaming() async {
    // Leave the Agora channel to stop live streaming
    await _rtcEngine.leaveChannel();

    // Set the live streaming state to false
    setState(() {
      _isLiveStreaming = false;
      _broadcastChannel = null;
    });
  }

  @override
  void dispose() {
    _rtcEngine.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Streaming'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_isLiveStreaming)
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: rtcView.SurfaceView(),
                ),
              )
            else
              Text(
                'Welcome to Live Streaming!',
                style: TextStyle(fontSize: 20),
              ),
            SizedBox(height: 20),
            if (!_isLiveStreaming)
              ElevatedButton(
                onPressed: startLiveStreaming,
                child: Text('Start Live Streaming'),
              )
            else
              ElevatedButton(
                onPressed: stopLiveStreaming,
                child: Text('Stop Live Streaming'),
              ),
          ],
        ),
      ),
    );
  }
}



